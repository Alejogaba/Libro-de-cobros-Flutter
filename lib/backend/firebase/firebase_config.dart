import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyA67qVTBV0Ie7Lzms7hJX6ozqbDkfIQnlA",
            authDomain: "proyecto-cobros.firebaseapp.com",
            projectId: "proyecto-cobros",
            storageBucket: "proyecto-cobros.appspot.com",
            messagingSenderId: "664667660844",
            appId: "1:664667660844:web:663817ebd1582ccbcc2789",
            measurementId: "G-NQV9FZ04SN"));
  } else {
    await Firebase.initializeApp();
  }
}
