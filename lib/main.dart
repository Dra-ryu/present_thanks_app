import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:present_thanks/welcome.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  LineSDK.instance.setup('1657442387').then((_) {
    print('LineSDK prepared');
  });
  runApp(Login());
}

