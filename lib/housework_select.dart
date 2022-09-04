import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:present_thanks/stopwatch.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'footer.dart';
import 'header.dart';

class houseworkSelect extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFFfcf4c4),
        appBar: Header(),
        body: HouseworkSelectPage(),
        bottomNavigationBar: Footer(currentPageIndex: 0),
      ),
    );
  }
}

class HouseworkSelectPage extends StatefulWidget {
  @override
  HouseworkSelectPageState createState() => HouseworkSelectPageState();
}


class HouseworkSelectPageState extends State<HouseworkSelectPage> {

  String? selectedPartner;
  String selectedHousework = '';
  int currentPoint = 0;
  List<String> dropdownItems = [];
  String uemail = '';
  List searchedInformation = [];
  List friendsInformation = [];
  final _userInformations = FirebaseFirestore.instance.collection('users');
  final _friendInformations = FirebaseFirestore.instance.collection('friends');
  int friendCounter = 0;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    // ログイン情報を取り出す処理
    final user = await _auth.currentUser!;
    uemail = user.email!;

    setState(() {
      FirebaseFirestore.instance.collection('friends').where('userID', isEqualTo: uemail).get().then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((doc) {
          dropdownItems.add(doc.get('friendID'));
          friendCounter++;
        });
      });
    });

    // ログインしているユーザーのポイントをcloud firestoreから取り出す処理
    final QuerySnapshot snapshot = await _userInformations.where('userID', isEqualTo: uemail).get();
    final QuerySnapshot friendSnapshot = await _friendInformations.where('userID', isEqualTo: uemail).get();
    setState(() {

      final List gaps = snapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        searchedInformation = [
          data['userID'],
          data['point'],
        ];
      }).toList();

      final List aaa = friendSnapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        friendsInformation = [
          data['friendID'],
        ];
      }).toList();
    });
    currentPoint = searchedInformation[1];

  }

  // 入力した情報を一時的に保存する
  Future<void> _setData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('housework', selectedHousework);
      prefs.setString('partnerName', selectedPartner!);
      prefs.setInt('currentPoint', currentPoint);
    });
  }

  void change_button_state(houseworkName) {
    return setState((){
      selectedHousework = houseworkName;
      print("bbb");
    });
  }

  Expanded display_buttons(houseworkName) {
    return Expanded(
      child: TextButton(
        onPressed: (){
          change_button_state(houseworkName);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset("images/$houseworkName.png"),
        ),
        style: TextButton.styleFrom(
          primary: Colors.transparent,
          elevation: 0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        Container(
          height: size.height*0.2,
          width: double.infinity,
          color: Color(0xFFc4f4fc),
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: size.height*0.02)),
              Text('$uemailさんのありがとうポイントは'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('$currentPoint',
                    style: TextStyle(
                      fontSize: size.height*0.13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('pt'),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: size.width*0.03),
          width: double.infinity,
          child: Text('家事を選択してください',
          style: TextStyle(
            fontSize: size.height*0.025,
          ),
          textAlign: TextAlign.left),
        ),
        Row(
          children: [
            display_buttons("料理"),
            display_buttons("買い物"),
            display_buttons("掃除"),
          ],
        ),
        Row(
          children: [
            display_buttons("洗濯"),
            display_buttons("ゴミ出し"),
            display_buttons("送迎"),
          ],
        ),
        Divider(),  // 横線を入れる処理
        SizedBox(
          width: size.width*0.8,
          child: DropdownButton<String>(
            alignment: Alignment.center,
            value: selectedPartner,
            items: dropdownItems.map((list) => DropdownMenuItem(value: list, child: Text(list))).toList(),
            hint: Text('家事をする相手を選択してください'),
            onChanged: (String? value){
              setState(() {
                selectedPartner = value;
              });
            },
            isExpanded: true,
          ),
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
            onPressed: ()  {
              _setData();
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StopWatchApp())
              );
            },
          ),
        ),
      ],
    );
  }
}
