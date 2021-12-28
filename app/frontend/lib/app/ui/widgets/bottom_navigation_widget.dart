import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

Widget bottomNavBarItem(
    Color _color, String _page, IconData _icon, double _size) {
  return Padding(
    padding: EdgeInsets.all(10),
    child: IconButton(
      onPressed: () {
        Get.toNamed(_page);
      },
      icon: Icon(
        _icon,
        size: _size,
        color: _color,
      ),
    ),
  );
}

Widget bottomNavBar(BuildContext context, int currentIndex) {
  List<Widget> items = [
    bottomNavBarItem(Colors.grey, '/profile', LineIcons.box, 32),
    bottomNavBarItem(Colors.white, '/camera', LineIcons.recordVinyl, 32),
    bottomNavBarItem(Colors.grey, '/feed', LineIcons.eye, 32),
  ];

  switch (currentIndex) {
    case 0:
      items = [
        bottomNavBarItem(Colors.grey, '/profile', LineIcons.box, 32),
        bottomNavBarItem(Colors.white, '/camera', LineIcons.recordVinyl, 32),
        bottomNavBarItem(Colors.grey, '/feed', LineIcons.eye, 32),
      ];
      break;
    case 1:
      items = [
        bottomNavBarItem(Colors.grey, '/camera', LineIcons.recordVinyl, 32),
        bottomNavBarItem(Colors.white, '/profile', LineIcons.box, 32),
        bottomNavBarItem(Colors.grey, '/feed', LineIcons.eye, 32),
      ];
      break;
    case 2:
      items = [
        bottomNavBarItem(Colors.grey, '/camera', LineIcons.recordVinyl, 32),
        bottomNavBarItem(Colors.white, '/feed', LineIcons.eye, 32),
        bottomNavBarItem(Colors.grey, '/profile', LineIcons.box, 32),
      ];
      break;
  }

  return Positioned(
    bottom: 10,
    child: Container(
      color: Colors.transparent,
      constraints: BoxConstraints(minWidth: 300, maxWidth: 500),
      width: MediaQuery.of(context).size.width,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: items),
    ),
  );
}
