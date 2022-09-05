import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:present_thanks/header.dart';
import 'housework_select.dart';

class Login extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFFfcf4c4),
        appBar: Header(),
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

  void _signIn() async {
      final result = await LineSDK.instance.login();
      // user id -> result.userProfile?.userId
      // user name -> result.userProfile?.displayName
      // user avatar -> result.userProfile?.pictureUrl
      print(result.userProfile?.userId);

      await FirebaseFirestore.instance
          .collection('users').doc(result.userProfile?.userId).get().then((docSnapshot) =>
      {
        if (!docSnapshot.exists) {
          FirebaseFirestore.instance.collection('users').doc(
              result.userProfile?.userId).set({
            'point': 0,
            'userID': result.userProfile?.userId,
            'userName': result.userProfile?.displayName,
          })
        }
      });
  }

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
            SizedBox(
              height: size.height * 0.02,
            ),
            Container(
              // メッセージ表示
              child: Text(infoLoginText),
            ),
            SizedBox(
              width: 300,
              child: ElevatedButton(
                child: const Text('LINEで登録・ログイン'),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF54c404),
                  onPrimary: Colors.white,
                  shape: const StadiumBorder(),
                ),
                // ログインの確認
                onPressed: () async {
                  _signIn();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => houseworkSelect()
                    )
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}