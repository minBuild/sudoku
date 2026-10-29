import java.util.Properties
import java.io.FileInputStream
import org.jetbrains.kotlin.gradle.dsl.JvmTarget

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

// Google 샘플 AdMob App ID (Android)
val testAdmobAppId = "ca-app-pub-3940256099942544~3347511713"

// 공개값(APK 평문). README §광고 ID 위치
val prodAdmobAppId = "ca-app-pub-7432278320907197~1580424878"
require(prodAdmobAppId.isEmpty() || Regex("""ca-app-pub-\d{16}~\d{10}""").matches(prodAdmobAppId)) { "prodAdmobAppId 형식 오류" }
val releaseRequested = gradle.startParameter.taskNames.any { it.contains("Release", ignoreCase = true) }

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.jang.sudoku"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.jang.sudoku"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = maxOf(flutter.minSdkVersion, 24)
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        // profile 등 별도 지정이 없는 빌드 타입은 테스트 App ID 를 쓴다.
        manifestPlaceholders["admobAppId"] = testAdmobAppId
    }

    signingConfigs {
        if (keystorePropertiesFile.exists()) create("release") {
            keyAlias = keystoreProperties.getProperty("keyAlias") ?: error("key.properties: keyAlias 누락")
            keyPassword = keystoreProperties.getProperty("keyPassword") ?: error("key.properties: keyPassword 누락")
            storeFile = file(keystoreProperties.getProperty("storeFile") ?: error("key.properties: storeFile 누락"))
            storePassword = keystoreProperties.getProperty("storePassword") ?: error("key.properties: storePassword 누락")
        }
    }

    buildTypes {
        debug {
            manifestPlaceholders["admobAppId"] = testAdmobAppId
        }
        release {
            signingConfig = if (keystorePropertiesFile.exists()) {
                signingConfigs.getByName("release")
            } else {
                if (releaseRequested) {
                    logger.warn("key.properties 없음: release 를 debug 키로 서명합니다 → Play 업로드 불가")
                }
                signingConfigs.getByName("debug")
            }
            manifestPlaceholders["admobAppId"] = prodAdmobAppId.ifEmpty {
                if (releaseRequested) logger.warn("prodAdmobAppId 비어 있음: 테스트 App ID, 광고 skipped")
                testAdmobAppId
            }
        }
    }
}

flutter {
    source = "../.."
}

// Kotlin 2.3 부터 kotlinOptions.jvmTarget 은 컴파일 오류 → compilerOptions DSL (README §Firebase)
kotlin {
    compilerOptions {
        jvmTarget.set(JvmTarget.JVM_17)
    }
}
