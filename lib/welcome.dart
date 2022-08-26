import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'housework_select.dart';
import 'main.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  late String email;
  late String password;
  String infoLoginText = '';
  String infoRegisterText = '';



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/thanks.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),

              //ログイン部分
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration:
                InputDecoration(hintText: 'Enter your username'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: InputDecoration(
                    hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              Container(
                padding: EdgeInsets.all(8),
                // メッセージ表示
                child: Text(infoLoginText),
              ),
              SizedBox(
                width: 300,
                child: ElevatedButton(
                  child: const Text('ログイン'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                    onPrimary: Colors.black,
                    shape: const StadiumBorder(),
                  ),
                  // ログインの確認
                  onPressed: () async {
                    try {
                      await _auth.signInWithEmailAndPassword(
                          email: email,
                          password: password
                      );
                      // ログイン成功の場合
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => houseworkSelect())
                      );
                    }
                    catch (e) {
                      // ユーザー登録に失敗した場合
                      setState(() {
                        infoLoginText = "登録に失敗しました：${e.toString()}";
                      });
                    }

                    print(email);
                    print(password);
                  },
                ),
              ),

              // 登録部分
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration:
                InputDecoration(hintText: 'Enter your username'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: InputDecoration(
                    hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              Container(
                padding: EdgeInsets.all(8),
                // メッセージ表示
                child: Text(infoRegisterText),
              ),
              SizedBox(
                width: 300,
                child: ElevatedButton(
                  child: const Text('登録'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                    onPrimary: Colors.black,
                    shape: const StadiumBorder(),
                  ),
                  // ボタン押されたときにユーザー登録する
                  onPressed: () async {
                    try {
                      final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);

                      await FirebaseFirestore.instance
                          .collection('users').add({
                        'point': 0,
                        'userID': email,
                      });

                      print("aaa");
                      if (newUser != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => houseworkSelect())
                        );
                      }
                    }
                    catch (e) {
                      // ユーザー登録に失敗した場合
                      setState(() {
                        infoRegisterText = "登録に失敗しました：${e.toString()}";
                      });
                    }

                    print(email);
                    print(password);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}