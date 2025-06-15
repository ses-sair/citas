// Configuración de Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseOptions {
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY',
    appId: '1:123456789012:web:abcdef123456789012',
    messagingSenderId: '123456789012',
    projectId: 'citas-app-demo',
    authDomain: 'citas-app-demo.firebaseapp.com',
    storageBucket: 'citas-app-demo.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: '1:123456789012:android:abcdef123456789012',
    messagingSenderId: '123456789012',
    projectId: 'citas-app-demo',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: '1:123456789012:ios:abcdef123456789012',
    messagingSenderId: '123456789012',
    projectId: 'citas-app-demo',
    iosBundleId: 'com.example.citasApp',
  );
}

class FirebaseConfig {
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: _getFirebaseOptions(),
    );
  }

  static FirebaseOptions _getFirebaseOptions() {
    // For demo purposes, we'll use a mock configuration
    // In production, replace with actual Firebase credentials
    return const FirebaseOptions(
      apiKey: 'demo-api-key',
      appId: 'demo-app-id', 
      messagingSenderId: 'demo-sender-id',
      projectId: 'citas-app-demo',
      authDomain: 'citas-app-demo.firebaseapp.com',
      storageBucket: 'citas-app-demo.appspot.com',
    );
  }
}
