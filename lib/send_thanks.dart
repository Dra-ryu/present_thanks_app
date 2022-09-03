import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'housework_select.dart';

class SendThanks extends StatelessWidget {
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
  bool showSpinner = false;
  late String email;
  late String password;
  String infoLoginText = '';
  String infoRegisterText = '';

  int counter = 0;
  String uid = "";
  String? isSelectedItem;
  List<String> dropdownItems = [];
  String uemail = '';
  int currentPoint = 0;
  String friendDocID = '';
  List searchedInformation = [];

  void incrementCounter() {
    setState(() {
      counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  final _auth = FirebaseAuth.instance;

  void init() async {
    // ログインしているユーザーの情報を取得する
    final user = await _auth.currentUser!;
    uemail = user.email!;
    uid = user.uid;

    // shared_preferenceから値を取得する
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentPoint = prefs.getInt('currentPoint')!;
    });

    print("ああああがおj");
    setState(() {
      FirebaseFirestore.instance.collection('friends').where('userID', isEqualTo: uemail).get().then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((doc) {
          // usersコレクションのドキュメントIDを取得する
          print(doc.id);
          // 取得したドキュメントIDのフィールド値nameの値を取得する
          print(doc.get('friendID'));
          dropdownItems.add(doc.get('friendID'));
          print("アイウエオ");
          print(dropdownItems);
        });
      });
    });
    print(dropdownItems);
  }

  void getFriendDocID() async {
    setState((){
      FirebaseFirestore.instance.collection('users').get().then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((doc) {
          print("🥒");
          // ループの中で、情報が一致したときのdoc idを取り出せば良い
          if (doc.get('userID') == isSelectedItem) {
            setState((){
              friendDocID = doc.id;
            });
            print("🍅");
            print(friendDocID);
          }
        });
      });
    });

    // ログインしているユーザーのポイントをcloud firestoreから取り出す処理
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').where('userID', isEqualTo: isSelectedItem).get();
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
            DropdownButton<String>(
              value: isSelectedItem,
              items: dropdownItems.map((list) => DropdownMenuItem(value: list, child: Text(list))).toList(),

              onChanged: (String? value){
                setState(() {
                  isSelectedItem = value;
                  getFriendDocID();
                });
              },
            ),
            Text('$counter'),
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
            SizedBox(
              height: size.height * 0.05,
            ),

            SizedBox(
              width: 300,
              child: ElevatedButton(
                  child: const Text('決定'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                    onPrimary: Colors.black,
                    shape: const StadiumBorder(),
                  ),
                  // ボタン押されたときにユーザー登録する
                  onPressed: () {
                    print('はいはいはい');
                    print(friendDocID);
                    FirebaseFirestore.instance.collection('users').doc(friendDocID).update({
                      'point': currentPoint + counter,
                    });
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