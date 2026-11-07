# ProGuard & R8 Configuration for Nikahin App

# 1. Flutter Framework
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# 2. Keep Annotations
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keepattributes Signature
-keepattributes InnerClasses,EnclosingMethod

# 3. Drift & SQLite3
-keep class com.tekartik.sqflite.** { *; }
-keep class org.sqlite.** { *; }

# 4. In-App Updater & OpenFileX
-keep class com.crazecoder.openfile.** { *; }

# 5. Core Desugaring & Kotlin Coroutines
-dontwarn java.lang.invoke.**
-dontwarn java.util.concurrent.**

