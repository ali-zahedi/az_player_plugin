
add android/app/AndroidManifest.xml
<service
    android:name="pro.zahedi.flutter.plugin.player.az_player_plugin.AudioService"
    android:enabled="true"
    android:exported="false">
</service>

in application section: 
android:usesCleartextTraffic="true"

Add the permission for foreground service in same AndroidManifest.xml .

 <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />

 STEP 3: Add the following dependency into android/app/build.graddle #

    android {
            compileOptions {
                sourceCompatibility JavaVersion.VERSION_1_8
                targetCompatibility JavaVersion.VERSION_1_8
            }
    }


In android/gradle/wrapper/gradle-wrapper.properties change the line starting with distributionUrl like this:

distributionUrl=https\://services.gradle.org/distributions/gradle-4.10.2-all.zip


In android/build.gradle, replace:

content_copy
dependencies {
    classpath 'com.android.tools.build:gradle:3.2.1'
}
by

content_copy
dependencies {
    classpath 'com.android.tools.build:gradle:3.3.0'
}



In android/gradle.properties, append

content_copy
android.enableJetifier=true
android.useAndroidX=true


In android/app/build.gradle:

Under android {, make sure compileSdkVersion and targetSdkVersion are at least 28.



Replace all deprecated libraries with the AndroidX equivalents. For instance, if you’re using the default .gradle files make the following changes:

In android/app/build.gradle

content_copy
testInstrumentationRunner "android.support.test.runner.AndroidJUnitRunner"
by

content_copy
testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
Finally, under dependencies {, replace

content_copy
androidTestImplementation 'com.android.support.test:runner:1.0.2'
androidTestImplementation 'com.android.support.test.espresso:espresso-core:3.0.2'
by

content_copy
androidTestImplementation 'androidx.test:runner:1.1.1'
androidTestImplementation 'androidx.test.espresso:espresso-core:3.1.1'
