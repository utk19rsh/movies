import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:suspense/app.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
