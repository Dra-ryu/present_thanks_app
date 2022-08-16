import 'package:flutter/material.dart';


void main() {
  return runApp(
    MaterialApp(
      print()
      home: Scaffold(
        backgroundColor: Color(0xFFfcf4c4),
        appBar: AppBar(
          title: Text(x'ありがとうを贈ろう'),
          titleTextStyle: TextStyle(
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
        ),
        body: DicePage(),
      ),
    ),
  );
}

class DicePage extends StatefulWidget {
  @override
  _DicePageState createState() => _DicePageState();
}

class _DicePageState extends State<DicePage> {
  double button_opacity = 1;

  bool _pressing = false;
  String? isSelectedItem = '原田龍之介';

  List<String> dropdownItems = ["原田龍之介", "原田", "龍之介"];

  void change_button_state() {
    return setState((){
      button_opacity = 0.5;
    });
  }

  Expanded display_buttons(houseworkName) {
    return Expanded(
      child: TextButton(
        onPressed: (){
          change_button_state();
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
    return Column(
      children: [
        Row(
          children: [
            display_buttons("thanks"),
            display_buttons("shopping"),
            display_buttons("cleaning"),
          ],
        ),
        Row(
          children: [
            display_buttons("washing"),
            display_buttons("puttingOutTrash"),
            display_buttons("driving"),
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
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => StopWatchModel())
            //   );
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
            },
          ),
        ),
      ],
    );
  }
}
