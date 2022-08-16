import 'package:flutter/material.dart';

class houseworkSelect extends StatefulWidget {
  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Present Thanks',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: Scaffold(
        appBar: AppBar(
          title: Text('ありがとうを贈ろう'),
        ),
      ),
    );
  }
}