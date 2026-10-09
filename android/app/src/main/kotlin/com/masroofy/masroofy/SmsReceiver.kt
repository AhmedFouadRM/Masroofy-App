package com.masroofy.masroofy

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.provider.Telephony

/**
 * Catches `SMS_RECEIVED` and hands each message to Dart (see [SmsBridge]).
 *
 * Deliberately thin: it only assembles the message and delivers it. Whether
 * the sender is a bank, what the text means and what to do with it are all
 * decided in Dart (`HandleIncomingSms`), so they are tested there.
 *
 * It does nothing when SMS Import is off. The switch lives in Flutter's
 * `shared_preferences`, which stores `sms_enabled` as `flutter.sms_enabled` in
 * the `FlutterSharedPreferences` file; the receiver reads that file directly.
 */
class SmsReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != Telephony.Sms.Intents.SMS_RECEIVED_ACTION) return
        if (!SmsBridge.isEnabled(context)) return

        val parts = Telephony.Sms.Intents.getMessagesFromIntent(intent)
        if (parts.isNullOrEmpty()) return

        // A long message arrives as several parts; join them per sender, in order.
        val bodies = LinkedHashMap<String, StringBuilder>()
        val times = HashMap<String, Long>()
        for (part in parts) {
            val sender = part.originatingAddress ?: continue
            bodies.getOrPut(sender) { StringBuilder() }.append(part.messageBody ?: "")
            times.putIfAbsent(sender, part.timestampMillis)
        }
        val messages = bodies.map { (sender, body) ->
            IncomingSms(sender, body.toString(), times[sender] ?: System.currentTimeMillis())
        }
        if (messages.isEmpty()) return

        // Keep the process alive until Dart has handled them (a broadcast
        // otherwise ends when onReceive returns).
        val pending = goAsync()
        SmsBridge.deliver(context.applicationContext, messages) { pending.finish() }
    }
}
