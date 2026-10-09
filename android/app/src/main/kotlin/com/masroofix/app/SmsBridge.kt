package com.masroofix.app

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.provider.Telephony
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Executors

/** One received message: what the phone delivered, and nothing more. */
data class IncomingSms(val sender: String, val body: String, val timestamp: Long)

/**
 * Delivers SMS to Dart and reads the inbox for the catch-up scan. Both ends
 * speak one MethodChannel, [CHANNEL]:
 *
 *  - `onSms {sender, body, timestamp}`, native to Dart, awaited: the receiver
 *    stays alive until Dart answers.
 *  - `readInbox {sinceMillis}`, Dart to native: the inbox as a list of
 *    `{sender, body, timestamp}`.
 *  - `ready`, Dart to native, from the headless engine only.
 *
 * If the app's own engine is running ([attach]), the message goes to it.
 * Otherwise a headless [FlutterEngine] starts the Dart entry point
 * `smsBackgroundMain` (lib/app/sms_background.dart), which opens the same
 * database, handles the message and answers.
 */
object SmsBridge {
    const val CHANNEL = "masroofy/sms"

    private const val DART_LIBRARY = "package:masroofy/app/sms_background.dart"
    private const val DART_FUNCTION = "smsBackgroundMain"

    /** FlutterSharedPreferences: shared_preferences' file, keys prefixed `flutter.`. */
    private const val PREFERENCES_FILE = "FlutterSharedPreferences"
    private const val ENABLED_KEY = "flutter.sms_enabled"

    /** A broadcast may run for about 10 seconds; leave a margin. */
    private const val HEADLESS_TIMEOUT_MS = 8_000L

    private const val MAX_INBOX_ROWS = 2_000

    private val main = Handler(Looper.getMainLooper())
    private val io = Executors.newSingleThreadExecutor()

    /** The channel of the app's running engine, or null when the app is closed. */
    @Volatile
    private var appChannel: MethodChannel? = null

    fun isEnabled(context: Context): Boolean =
        context.getSharedPreferences(PREFERENCES_FILE, Context.MODE_PRIVATE).getBoolean(ENABLED_KEY, false)

    // ── The app's engine ──

    /** Called by MainActivity when its engine is ready. */
    fun attach(engine: FlutterEngine, context: Context) {
        val channel = MethodChannel(engine.dartExecutor.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler { call, result -> handleCall(context.applicationContext, call, result) }
        appChannel = channel
    }

    /** Called when MainActivity's engine goes away. */
    fun detach(engine: FlutterEngine) {
        appChannel?.setMethodCallHandler(null)
        appChannel = null
    }

    private fun handleCall(context: Context, call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "readInbox" -> readInbox(context, call.argument<Number>("sinceMillis")?.toLong() ?: 0L, result)
            else -> result.notImplemented()
        }
    }

    // ── Delivering ──

    fun deliver(context: Context, messages: List<IncomingSms>, done: () -> Unit) {
        val channel = appChannel
        if (channel == null) deliverHeadless(context, messages, done) else deliverToApp(context, channel, messages, 0, done)
    }

    /** The app is running: its Dart handles the messages, in order. */
    private fun deliverToApp(
        context: Context,
        channel: MethodChannel,
        messages: List<IncomingSms>,
        index: Int,
        done: () -> Unit,
    ) {
        if (index >= messages.size) {
            done()
            return
        }
        // If the app's Dart is not listening (yet), the headless engine takes over.
        val fallback = { deliverHeadless(context, messages.drop(index), done) }
        channel.invokeMethod("onSms", messages[index].toMap(), object : MethodChannel.Result {
            override fun success(result: Any?) = deliverToApp(context, channel, messages, index + 1, done)
            override fun error(code: String, message: String?, details: Any?) = fallback()
            override fun notImplemented() = fallback()
        })
    }

    private fun deliverHeadless(context: Context, messages: List<IncomingSms>, done: () -> Unit) {
        if (messages.isEmpty()) {
            done()
            return
        }
        val loader = FlutterInjector.instance().flutterLoader()
        loader.startInitialization(context)
        loader.ensureInitializationComplete(context, null)

        val engine = FlutterEngine(context)
        var finished = false
        fun finish() {
            if (finished) return
            finished = true
            engine.destroy()
            done()
        }
        main.postDelayed({ finish() }, HEADLESS_TIMEOUT_MS)

        val channel = MethodChannel(engine.dartExecutor.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "ready" -> {
                    result.success(null)
                    sendAll(channel, messages, 0, ::finish)
                }
                else -> handleCall(context, call, result)
            }
        }
        engine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint(loader.findAppBundlePath(), DART_LIBRARY, DART_FUNCTION),
        )
    }

    private fun sendAll(channel: MethodChannel, messages: List<IncomingSms>, index: Int, finish: () -> Unit) {
        if (index >= messages.size) {
            finish()
            return
        }
        val next = { sendAll(channel, messages, index + 1, finish) }
        channel.invokeMethod("onSms", messages[index].toMap(), object : MethodChannel.Result {
            override fun success(result: Any?) = next()
            override fun error(code: String, message: String?, details: Any?) = next()
            override fun notImplemented() = next()
        })
    }

    private fun IncomingSms.toMap(): Map<String, Any> =
        mapOf("sender" to sender, "body" to body, "timestamp" to timestamp)

    // ── The inbox ──

    /** The catch-up scan: the inbox since [sinceMillis], newest first. Needs READ_SMS. */
    private fun readInbox(context: Context, sinceMillis: Long, result: MethodChannel.Result) {
        io.execute {
            try {
                val rows = ArrayList<Map<String, Any>>()
                context.contentResolver.query(
                    Telephony.Sms.Inbox.CONTENT_URI,
                    arrayOf(Telephony.Sms.ADDRESS, Telephony.Sms.BODY, Telephony.Sms.DATE),
                    "${Telephony.Sms.DATE} >= ?",
                    arrayOf(sinceMillis.toString()),
                    "${Telephony.Sms.DATE} DESC",
                )?.use { cursor ->
                    val address = cursor.getColumnIndexOrThrow(Telephony.Sms.ADDRESS)
                    val body = cursor.getColumnIndexOrThrow(Telephony.Sms.BODY)
                    val date = cursor.getColumnIndexOrThrow(Telephony.Sms.DATE)
                    while (cursor.moveToNext() && rows.size < MAX_INBOX_ROWS) {
                        val from = cursor.getString(address) ?: continue
                        rows.add(mapOf("sender" to from, "body" to (cursor.getString(body) ?: ""), "timestamp" to cursor.getLong(date)))
                    }
                }
                main.post { result.success(rows) }
            } catch (e: SecurityException) {
                main.post { result.error("permission", "READ_SMS is not granted", null) }
            } catch (e: Exception) {
                main.post { result.error("read_failed", e.message, null) }
            }
        }
    }
}
