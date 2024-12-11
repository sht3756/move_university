import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FirebaseConfig {
  static FirebaseOptions get options {
    return FirebaseOptions(
      apiKey:  dotenv.env[Platform.isAndroid ? 'ANDROID_API_KEY' : 'IOS_APP_KEY']!,
      projectId: dotenv.env['PROJECT_ID']!,
      storageBucket: dotenv.env['STORAGE_BUCKET']!,
      messagingSenderId: dotenv.env['MESSAGING_SENDER_ID']!,
      appId: dotenv.env[Platform.isAndroid ? 'ANDROID_APP_ID': 'IOS_APP_ID']!,
    );
  }
}