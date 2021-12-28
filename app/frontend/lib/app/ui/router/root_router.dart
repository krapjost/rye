import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rye/app/ui/profile/profile_page.dart';
import 'package:rye/app/ui/camera/camera_page.dart';
import 'package:rye/app/ui/feed/feed_page.dart';

class RootRouter extends StatefulWidget {
  @override
  _RootRouterState createState() => _RootRouterState();
}

class _RootRouterState extends State<RootRouter> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: Container(
        constraints: BoxConstraints(minWidth: 300, maxWidth: 500),
        child: Scaffold(
            body: Stack(
          children: [
            _pageOptions.elementAt(_selectedIndex),
            bottomNavBar(context),
          ],
        )),
      ),
    );
  }
}

Widget bottomNavBar(BuildContext context) {
  return Positioned(
    bottom: 0,
    child: Container(
      color: Colors.transparent,
      constraints: BoxConstraints(minWidth: 300, maxWidth: 500),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: IconButton(
              onPressed: () {
                Get.toNamed('/camera');
              },
              icon: Icon(LineIcons.plusSquare),
            ),
          ),
          IconButton(
            onPressed: () {
              Get.toNamed('/profile');
            },
            icon: Icon(LineIcons.plusSquare),
          ),
          IconButton(
            onPressed: () {
              Get.toNamed('/feed');
            },
            icon: Icon(LineIcons.plusSquare),
          ),
        ],
      ),
    ),
  );
}

List _pageOptions = [
  CameraPage(),
  ProfilePage(),
  FeedPage(),
];
