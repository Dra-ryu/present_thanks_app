import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import "package:intl/intl.dart";
import 'package:flutter/material.dart';
import 'package:present_thanks/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'housework_select.dart';

class StopWatchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer App',
      theme: ThemeData(
          primarySwatch: Colors.blueGrey
      ),

      home: Scaffold(
        backgroundColor: Color(0xFFfcf4c4),
        appBar: AppBar(
          title: Text('ありがとうを贈ろう'),
          titleTextStyle: TextStyle(
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
        ),
        body: StopwatchPage(),
      ),
    );
  }
}

class StopwatchPage extends StatefulWidget {
  @override
  _StopwatchPageState createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  late Timer _timer;
  final _formatter = DateFormat('HH:mm:ss');

  var StartTime = 0;
  var NowTime = 0;
  var RunState = 0; // 0:stop, 1:run

  String selectedHousework = "aaa";
  String partnerName = "";
  int currentPoint = 0;
  String uid = "";

  @override
  void initState() {
    print("ppp");
    super.initState();
    _timer = Timer.periodic(
      Duration(milliseconds: 123), // 数値小->高速に時間刻む
          (_t) => setState(() {}),
    );
    init();
  }

  final _auth = FirebaseAuth.instance;
  String uemail = '';
  final _userInformations = FirebaseFirestore.instance.collection('users');

  void init() async {
    // ログインしているユーザーの情報を取得する
    final user = await _auth.currentUser!;
    uid = user.uid;
    uemail = user.email!;

    // shared_preferenceから値を取得する
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedHousework = prefs.getString('housework')!;
      partnerName = prefs.getString('partnerName')!;
      currentPoint = prefs.getInt('currentPoint')!;
    });
    print('$selectedHouseworkです！！');
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (RunState==1){
      NowTime = DateTime.now().millisecondsSinceEpoch.toInt();
    }

    void _StartButton(){
      if (RunState == 0){
        StartTime = DateTime.now().millisecondsSinceEpoch.toInt();
        NowTime = DateTime.now().millisecondsSinceEpoch.toInt();
        RunState = 1;
      }
    }

    void _StopButton(){
      if (RunState == 1){
        RunState = 0;
      }
      else{
        StartTime = 0;
        NowTime = 0;
      }
    }

    final Size size = MediaQuery.of(context).size;

    var DiffTime = DateTime.fromMillisecondsSinceEpoch(NowTime - StartTime).toUtc();
    var houseworkMinutes = DiffTime.hour * 60 + DiffTime.minute;

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
                    Text('$selectedHouseworkを'),
                    Text('$houseworkMinutes分行いました'),
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

    var ButtonWidget = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 150,
          child: ElevatedButton(
            child: const Text('開始'),
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF04a404),
              onPrimary: Colors.black,
              shape: const StadiumBorder(),
            ),
            onPressed: _StartButton,
          ),
        ),

        SizedBox(
          width: 150,
          child: ElevatedButton(
            child: const Text('終了'),
            style: ElevatedButton.styleFrom(
              primary: Color(0xFFf4bc2c),
              onPrimary: Colors.black,
              shape: const StadiumBorder(),
            ),
            onPressed: () async {
              FirebaseFirestore.instance.collection('users').doc(uid).update({
                'point': currentPoint + houseworkMinutes,
              });

              _StopButton();
              showAlertToFinish();
              print(_formatter.format(DiffTime));
              print(DiffTime.minute);
              print(houseworkMinutes);
            },
    ),
    ),

    ],
    );



    var DiffWidget = Container(
      height: size.height*0.2,
      width: double.infinity,
      color: Color(0xFFc4f4fc),
      child: Center(
        child: Text(
          '${_formatter.format(DiffTime)}',
          style: TextStyle(fontSize: size.height*0.1),
        ),
      ),
    );

    var InfoWidget = Column(
      children: [
        Container(
          height: size.height*0.02,
        ),
        Text(
          '家事の種類：$selectedHousework',
          style: TextStyle(fontSize: 25),
        ),
        Divider(),
        Text(
          '相手の名前：$partnerName',
          style: TextStyle(fontSize: 25),
        ),
        Divider(),
      ],
    );

    return Column(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DiffWidget,
            InfoWidget,
            ButtonWidget,
          ],
        ),
      ],
    );
  }
}
