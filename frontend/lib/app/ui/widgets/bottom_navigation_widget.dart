import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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
  final String cameraPath = kIsWeb ? '/web-camera' : '/camera';
  List<Color> iconColors = [Colors.white, Colors.grey, Colors.grey];

  switch (currentIndex) {
    case 0:
      iconColors = [Colors.white, Colors.grey, Colors.grey];
      break;
    case 1:
      iconColors = [Colors.grey, Colors.white, Colors.grey];
      break;
    case 2:
      iconColors = [Colors.grey, Colors.grey, Colors.white];
      break;
  }

  List<Widget> items = [
    bottomNavBarItem(iconColors[0], cameraPath, LineIcons.phone, 32),
    bottomNavBarItem(iconColors[1], '/profile', LineIcons.circle, 32),
    bottomNavBarItem(iconColors[2], '/feed', LineIcons.alternateCommentAlt, 32),
  ];

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
