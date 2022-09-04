import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:present_thanks/welcome.dart';

import 'housework_select.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Login());
}