import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:present_thanks/header.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'footer.dart';
import 'housework_select.dart';

class SendThanks extends StatelessWidget {// static const String id = 'registration_screen';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Murecho',
      ),
      home: Scaffold(
        backgroundColor: Color(0xFFfcf4c4),
        appBar: Header(),
        body: Home(),
        bottomNavigationBar: Footer(currentPageIndex: 1),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  bool showSpinner = false;
  late String email;
  late String password;
  String infoLoginText = '';
  String infoRegisterText = '';

  int counter = 0;
  String? selectedPartner;
  List<String> dropdownItems = [];
  int currentPoint = 0;
  String friendDocID = '';
  List searchedInformation = [];
  late String loggedInUserName;
  late String loggedInUserID;

  void incrementCounter() {
    setState(() {
      if (counter < 20) {
        counter++;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    try {
      final result = await LineSDK.instance.getProfile();
      loggedInUserName = result.displayName;
      loggedInUserID = result.userId;
    } on PlatformException catch (e) {
      print(e.message);
    }

    setState(() {
      FirebaseFirestore.instance.collection('friends').where('userID', isEqualTo: loggedInUserID).get().then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((doc) {
          dropdownItems.add(doc.get('friendName'));
        });
      });
    });
  }

  void getFriendDocID() async {
    setState((){
      FirebaseFirestore.instance.collection('users').get().then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((doc) {
          // ループの中で、情報が一致したときのdoc idを取り出せば良い
          if (doc.get('userName') == selectedPartner) {
            setState((){
              friendDocID = doc.id;
            });
          }
        });
      });
    });

    // ログインしているユーザーのポイントをcloud firestoreから取り出す処理
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').where('userName', isEqualTo: selectedPartner).get();
    setState((){
      final List gaps = snapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        searchedInformation = [
          data['point'],
        ];
      }).toList();
      currentPoint = searchedInformation[0];
    });
  }

  getCounterText(size) {
    if (counter == 20) {
      return Text('$counter',
        style: TextStyle(
          color: Colors.red,
          fontSize: size.height*0.03,
          fontWeight: FontWeight.bold,
          ),
      );
    }
    else {
      return Text('$counter',
          style: TextStyle(
            fontSize: size.height*0.025,
          ),
      );
    }
  }

  Future<void> showAlertToFinish() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              width: 311.0,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent, width: 3),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top:10),
                  ),
                  Text('$selectedPartnerさんに'),
                  Text('$counterありがとうポイントを贈りました！'),
                  const SizedBox(
                    height: 24.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.grey,
                          elevation: 5,
                          primary: Colors.blueAccent,
                          onPrimary: Colors.white,
                          shape: const StadiumBorder(),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => houseworkSelect())
                          );
                        },
                        child: const Padding(
                          padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 36),
                          child: Text('OK'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                ],
              ),
            ),
          );
        });
  }

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
            Center(
              child: SizedBox(
                width: size.width*0.8,
                child: DropdownButton<String>(
                  alignment: Alignment.center,
                  value: selectedPartner,
                  items: dropdownItems.map((list) => DropdownMenuItem(value: list, child: Text(list))).toList(),
                  hint: Text('贈る相手を選択してください'),
                  onChanged: (String? value){
                    setState(() {
                      selectedPartner = value;
                    });
                    getFriendDocID();
                  },
                  isExpanded: true,
                ),
              ),
            ),
            Center(
                child: Padding(
                  padding: EdgeInsets.only(top: size.height*0.01),
                  child: Text('感謝の気持ちを込めて下のボタンを押しましょう！'),
                )
            ),
            Flexible(
              child: TextButton(
                onPressed: (){
                  incrementCounter();
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset("images/thanks.png"),
                ),
                style: TextButton.styleFrom(
                  primary: Colors.transparent,
                  elevation: 0,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('贈るありがとうポイント：',
                  textAlign: TextAlign.center
                ),
                getCounterText(size),
              ],
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            SizedBox(
              width: 300,
              child: ElevatedButton(
                  child: const Text('決定'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF54c404),
                    onPrimary: Colors.white,
                    shape: const StadiumBorder(),
                  ),
                  // ボタン押されたときにユーザー登録する
                  onPressed: () {
                    print(friendDocID);
                    FirebaseFirestore.instance.collection('users').doc(friendDocID).update({
                      'point': currentPoint + counter,
                    });
                    showAlertToFinish();
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}