import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:present_thanks/header.dart';
import 'package:present_thanks/register.dart';
import 'housework_select.dart';

class Login extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFFfcf4c4),
        appBar: Header(),
        body: Home(),
        bottomNavigationBar: FooterOfWelcome(),
      ),
    );
  }
}

class FooterOfWelcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text('アカウント作成はこちらから'),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Register())
        );
      },
    );
  }
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  late String email;
  late String password;
  String infoLoginText = '';
  String infoRegisterText = '';

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;  // 画面のサイズを取得する

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.height * 0.03),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/title.png'),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),

            //ログイン部分
            TextFormField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                email = value;
              },
              decoration: InputDecoration(
                hintText: 'メールアドレス',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            TextFormField(
              obscureText: true,
              textAlign: TextAlign.center,
              onChanged: (value) {
                password = value;
              },
              decoration: InputDecoration(
                hintText: 'パスワード',
                border: OutlineInputBorder(),
              ),
            ),
            Container(
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
          ],
        ),
      ),
    );
  }
}