import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:present_thanks/footer.dart';
import 'package:present_thanks/header.dart';

import 'housework_select.dart';

class Friends extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFFfcf4c4),
        appBar: Header(),
        body: FriendAdd(),
        bottomNavigationBar: Footer(currentPageIndex: 2),
      ),
    );
  }
}

class FriendAdd extends StatefulWidget {
  @override
  FriendAddState createState() => FriendAddState();
}

class FriendAddState extends State<FriendAdd> {
  String inputFriendName = '';
  List searchedInformation = [];
  final _userInformations = FirebaseFirestore.instance.collection('users');
  late String loggedInUserName;
  late String loggedInUserID;

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
  }

  Future<void> showAlertToRegster() {
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
                  Text('$inputFriendNameさんを'),
                  Text('パートナーに登録しました！'),
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
    final Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        Container(
          height: size.height*0.05,
          width: double.infinity,
          color: Color(0xFFc4f4fc),
          child: Text('友人検索'),
          padding: EdgeInsets.symmetric(vertical: size.height*0.01),
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
        Container(
          height: size.height*0.2,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.height * 0.03),
            child: Column(
              children: [
                // フレンドの検索部分
                TextFormField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    inputFriendName = value;
                  },
                  decoration: InputDecoration(
                    hintText: '検索したいLINEの名前を入力してください',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    child: const Text('検索'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey,
                      onPrimary: Colors.black,
                      shape: const StadiumBorder(),
                    ),
                    onPressed: ()  async {
                      final QuerySnapshot snapshot = await _userInformations.where('userName', isEqualTo: inputFriendName).get();
                      setState(() {

                        final List gaps = snapshot.docs.map((DocumentSnapshot document) {
                          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                          searchedInformation = [
                            data['userID'],
                            data['userName'],
                            data['point'],
                          ];
                        }).toList();
                      });
                      await FirebaseFirestore.instance
                          .collection('friends').add({
                        'userID': loggedInUserID,
                        'friendID': searchedInformation[0],
                        'friendName': searchedInformation[1],
                      });
                      showAlertToRegster();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
