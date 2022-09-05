import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
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
      debugShowCheckedModeBanner: false,
    );
  }
}

class HouseworkSelectPage extends StatefulWidget {
  @override
  HouseworkSelectPageState createState() => HouseworkSelectPageState();
}

class HouseworkSelectPageState extends State<HouseworkSelectPage> {

  String? selectedPartner;
  String selectedHousework = '未選択';
  int currentPoint = 0;
  List<String> dropdownItems = [];
  List searchedInformation = [];
  final _userInformations = FirebaseFirestore.instance.collection('users');
  String? loggedInUserName;
  String? loggedInUserID;
  bool _isHouseworkSelected = false;
  bool _isPartnerSelected = false;


  @override
  void initState() {
    super.initState();
    init();
  }

  // LINEのログイン情報を取得
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

    // ログインしているユーザーのポイントをcloud firestoreから取り出す処理
    final QuerySnapshot snapshot = await _userInformations.where('userID', isEqualTo: loggedInUserID).get();
    setState(() {

      final List getUserInfo = snapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        searchedInformation = [
          data['userID'],
          data['point'],
        ];
      }).toList();
    });
    currentPoint = searchedInformation[1];
  }

  // 入力した情報を一時的に保存してストップウォッチ画面で示す処理
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
    });
  }

  Expanded display_buttons(houseworkName) {
    return Expanded(
      child: TextButton(
        onPressed: (){
          change_button_state(houseworkName);
          _isHouseworkSelected = true;
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
              Text('あり贈さんのありがとうポイントは'),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('選択した家事：',
              style: TextStyle(
                fontSize: size.height*0.025,
              ),
            ),
            Text('$selectedHousework',
              style: TextStyle(
                fontSize: size.height*0.025,
                fontWeight: FontWeight.bold,
              ),
            ),
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
                _isPartnerSelected = true;
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
            onPressed: !_isHouseworkSelected || !_isPartnerSelected ? null : ()  {
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
