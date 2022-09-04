import 'package:flutter/material.dart';
import 'package:present_thanks/send_thanks.dart';

import 'friends.dart';
import 'housework_select.dart';

class Footer extends StatefulWidget {
  int currentPageIndex;
  Footer({required this.currentPageIndex});

  @override
  FooterState createState() => FooterState(PageIndex: currentPageIndex);
}

class FooterState extends State<Footer> {
  int? PageIndex;
  FooterState({required this.PageIndex});

  int _selectedIndex = 0;
  final _bottomNavigationBarItems =  <BottomNavigationBarItem>[];

  // アイコン情報
  static const _footerIcons = [
    Icons.cleaning_services_outlined,
    Icons.favorite_border_outlined,
    Icons.group_add_outlined,
    Icons.logout_outlined,
  ];

  // アイコン文字列
  static const _footerItemNames = [
    '家事選択',
    '贈る',
    'パートナー',
    'ログアウト',
  ];

  List pages = [
    houseworkSelect(),
    SendThanks(),
    Friends(),
  ];

  @override
  void initState() {
    super.initState();
    for ( var i = 0; i < _footerItemNames.length; i++) {
      if (i == PageIndex) {
        _bottomNavigationBarItems.add(_UpdateActiveState(i));
      }
      else {
        _bottomNavigationBarItems.add(_UpdateDeactiveState(i));
      }
    }
  }

  /// インデックスのアイテムをアクティベートする
  BottomNavigationBarItem _UpdateActiveState(int index) {
    return BottomNavigationBarItem(
        icon: Icon(
          _footerIcons[index],
          color: Colors.black87,
        ),
        label: _footerItemNames[index],
    );
  }

  /// インデックスのアイテムをディアクティベートする
  BottomNavigationBarItem _UpdateDeactiveState(int index) {
    return BottomNavigationBarItem(
        icon: Icon(
          _footerIcons[index],
          color: Colors.black26,
        ),
        label: _footerItemNames[index],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _bottomNavigationBarItems[_selectedIndex] = _UpdateDeactiveState(_selectedIndex);
      _bottomNavigationBarItems[index] = _UpdateActiveState(index);
      _selectedIndex = index;
    });
    print(_selectedIndex);
    print(index);
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => pages[index])
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, // これを書かないと3つまでしか表示されない
      items: _bottomNavigationBarItems,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }
}