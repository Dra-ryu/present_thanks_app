import 'dart:math';
import 'package:flutter/material.dart';


void main() {
  return runApp(
    MaterialApp(
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
    ),
  );
}

class DicePage extends StatefulWidget {
  @override
  _DicePageState createState() => _DicePageState();
}

class _DicePageState extends State<DicePage> {
  int leftDiceNumber = 2;
  int rightDiceNumber = 3;

  void change_dice_num() {
    return setState((){
      leftDiceNumber = Random().nextInt(6) + 1;  // 0にならないようにする処理
      rightDiceNumber = Random().nextInt(6) + 1;
      print("$leftDiceNumber");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FlatButton(
            onPressed: (){
              change_dice_num();
            },
            child: Image.asset("images/thanks.png"),
          ),
        ),
        Expanded(
          child: FlatButton(
            onPressed: (){
              change_dice_num();
            },
            child: Image.asset("images/thanks.png"),
          ),
        ),

      ],

    );
  }
}