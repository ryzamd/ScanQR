plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.scan_qr"
    compileSdk = 35

    defaultConfig {
        applicationId = "com.example.scan_qr"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            signingConfig = signingConfigs.getByName("debug")
        }
        debug {
            // Remove or comment out any references to isShrinkeResources
        }

        getByName("debug") {
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    flavorDimensions.add("app")
    productFlavors {
        create("qcManager") {
            dimension = "app"
            applicationIdSuffix = ".qc"
            versionNameSuffix = "-qc"
            resValue("string", "app_name", "QC Manager")
        }
        create("warehouseInbound") {
            dimension = "app"
            applicationIdSuffix = ".inbound"
            versionNameSuffix = "-inbound"
            resValue("string", "app_name", "Warehouse Inbound")
        }
        create("warehouseOutbound") {
            dimension = "app"
            applicationIdSuffix = ".outbound"
            versionNameSuffix = "-outbound"
            resValue("string", "app_name", "Warehouse Outbound")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation(platform("org.jetbrains.kotlin:kotlin-bom:1.9.0"))
}