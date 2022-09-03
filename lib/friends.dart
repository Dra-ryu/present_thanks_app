import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Friends extends StatelessWidget {

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
        body: FriendAdd(),
      ),
    );
  }
}

class FriendAdd extends StatefulWidget {
  @override
  FriendAddState createState() => FriendAddState();
}


class FriendAddState extends State<FriendAdd> {

  String inputFriendEmail = '';
  List searchedInformation = ['a', 'b', 'c'];
  final _userInformations = FirebaseFirestore.instance.collection('users');
  final _auth = FirebaseAuth.instance;
  String loggedInUserEmail = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    final user = await _auth.currentUser!;
    loggedInUserEmail = user.email!;
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
                    inputFriendEmail = value;
                  },
                  decoration: InputDecoration(
                    hintText: '検索したいメールアドレスを入力してください',
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
                      print(inputFriendEmail);
                      final QuerySnapshot snapshot = await _userInformations.where('userID', isEqualTo: inputFriendEmail).get();
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
                      print(searchedInformation);

                      await FirebaseFirestore.instance
                          .collection('friends').add({
                        'userID': loggedInUserEmail,
                        'friendID': inputFriendEmail,
                      });

                      // // 該当のメールアドレスがなかった場合
                      // if (searchedInformation == ['a', 'b', 'c']) {
                      //
                      // }
                    },
                  ),
                ),
                Text(searchedInformation[0]),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
