import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'housework_select.dart';

class RegistrationScreen extends StatelessWidget {
  // static const String id = 'registration_screen';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFFfcf4c4),
        appBar: AppBar(
          title: Text('ありがとうを贈ろう'),
          titleTextStyle: TextStyle(
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
        ),
        body: Home(),
      ),
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
                  child: Image.asset('images/thanks.png'),
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
            // ログイン部分と登録部分の間
            SizedBox(
              height: size.height * 0.01,
            ),
            // 登録部分
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
              height: 8.0,
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
                  print(size);
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);


                    // 上のFirebaseAuthから、uidを取得する変数を定義
                    final user = newUser.user;
                    final uuid = user?.uid;
                    // usersコレクションを作成して、uidとドキュメントidを一致させるプログラムを定義
                    await FirebaseFirestore.instance
                        .collection('users').doc(uuid).set({
                      'uid': uuid,
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

            SizedBox(
              width: 300,
              child: ElevatedButton(
                child: const Text('テスト用ボタン'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey,
                  onPrimary: Colors.black,
                  shape: const StadiumBorder(),
                ),
                // ボタン押されたときにユーザー登録する
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => houseworkSelect())
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}