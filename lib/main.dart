import 'package:flutter/material.dart';
import 'package:present_thanks/stopwatch.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

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
          body: DicePage(),
        ),
      );
  }
}

class DicePage extends StatefulWidget {
  @override
  _DicePageState createState() => _DicePageState();
}

class _DicePageState extends State<DicePage> {
  double button_opacity = 1;

  bool _pressing = false;
  String? isSelectedItem = '原田龍之介';
  String selectedHousework = '';
  int currentPoint = 0;  // Todo firebaseからポイントを取得する処理

  List<String> dropdownItems = ["原田龍之介", "原田", "龍之介"];

  // 入力した情報を一時的に保存する
  Future<void> _setData() async {
    print("aaccac");
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('housework', selectedHousework);
      prefs.setString('partnerName', isSelectedItem!);
    });
    String? ho = prefs.getString('housework');
    print('$hoアイウエオ');
  }

  void change_button_state(houseworkName) {
    return setState((){
      selectedHousework = houseworkName;
      button_opacity = 0.9;
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
              Text('あなたのポイントは'),
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
        DropdownButton(
            items: [
              DropdownMenuItem(
                child: Text(dropdownItems[0]),
                value: dropdownItems[0],
              ),
              DropdownMenuItem(
                child: Text(dropdownItems[1]),
                value: dropdownItems[1],
              ),
              DropdownMenuItem(
                child: Text(dropdownItems[2]),
                value: dropdownItems[2],
              ),
            ],
          onChanged: (String? value){
            setState(() {
              isSelectedItem = value;
            });
          },
          value: isSelectedItem,

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
            onPressed: ()  {
              _setData();
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StopWatchApp())
              );
            },
          ),
        ),

        SizedBox(
          width: 300,
          child: ElevatedButton(
            child: const Text('戻る'),
            style: ElevatedButton.styleFrom(
              primary: Colors.grey,
              onPrimary: Colors.black,
              shape: const StadiumBorder(),
            ),
            onPressed: ()  {
              print("aa");
              print(selectedHousework);
              print(isSelectedItem);
              _setData();
            },
          ),
        ),
      ],
    );
  }
}
