import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Release signing: android/key.properties (gitignored) points at the upload keystore.
val keyProperties = Properties()
val keyPropertiesFile = rootProject.file("key.properties")
val hasReleaseKey = keyPropertiesFile.exists()
if (hasReleaseKey) {
    keyPropertiesFile.inputStream().use { keyProperties.load(it) }
} else {
    logger.warn("WARNING: android/key.properties not found; release builds are signed with the DEBUG key. Not for Play upload.")
}

android {
    namespace = "com.masroofix.app"
    compileSdk = 37
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // flutter_local_notifications needs core library desugaring.
        isCoreLibraryDesugaringEnabled = true
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.masroofix.app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasReleaseKey) {
            create("release") {
                storeFile = file(keyProperties.getProperty("storeFile"))
                storePassword = keyProperties.getProperty("storePassword")
                keyAlias = keyProperties.getProperty("keyAlias")
                keyPassword = keyProperties.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            // Upload key when key.properties exists, else the debug key so
            // `flutter run --release` keeps working locally.
            signingConfig = if (hasReleaseKey) signingConfigs.getByName("release") else signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}

flutter {
    source = "../.."
}

// Release builds must not ship silently with system Arabic: the licensed
// Thmanyah fonts are gitignored and must be installed on the build machine.
val checkThmanyahFonts = tasks.register("checkThmanyahFonts") {
    val fontDir = file("../../assets/fonts/thmanyah")
    doLast {
        val fonts = fontDir.listFiles { f -> f.extension.lowercase() in listOf("otf", "ttf") }
        if (fonts == null || fonts.isEmpty()) {
            throw GradleException(
                "Thmanyah fonts are missing from assets/fonts/thmanyah/ (no .otf/.ttf files). " +
                    "Run `dart run tool/install_thmanyah.dart <dir>` before a release build."
            )
        }
    }
}

tasks.configureEach {
    if (name == "assembleRelease" || name == "bundleRelease") {
        dependsOn(checkThmanyahFonts)
    }
}
