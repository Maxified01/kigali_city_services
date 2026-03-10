plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    // Apply the Google services plugin
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.kigali_city_services"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.kigali_city_services"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// Optional: If you want to add Firebase BoM and SDKs (usually not needed with FlutterFire)
// dependencies {
//     implementation(platform("com.google.firebase:firebase-bom:34.10.0"))
//     // Add any Android-specific Firebase SDKs if needed
// }