import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FirebaseService {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyBi8rhHWj45KSNEQN4s1eKj7tcWOElQhnA",
          appId: "1:1047711640477:web:3d64f17f1393a4f0b99d74",
          messagingSenderId: "1047711640477",
          projectId: "studentunionvs",
           databaseURL: "https://studentunionvs-default-rtdb.firebaseio.com/",       
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
  }

  static FirebaseFirestore get firestore => FirebaseFirestore.instance;
    static FirebaseDatabase get database => FirebaseDatabase.instance;
  
}
