import 'package:flutter/material.dart';
import 'package:rye/app/ui/profile/profile_page.dart';
import 'package:rye/app/ui/phone/phone_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:line_icons/line_icons.dart';

List<Widget> pages = [
  PhonePage(),
  ProfilePage(),
  Center(child: Text("page 3", style: TextStyle(color: Colors.white))),
];

class RootRouter extends StatefulWidget {
  const RootRouter({Key? key}) : super(key: key);

  @override
  RootRouterState createState() => RootRouterState();
}

class RootRouterState extends State<RootRouter> {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        color: Colors.brown.withOpacity(0.3),
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.brown.shade800,
        animationDuration: Duration(milliseconds: 200),
        animationCurve: Curves.easeOutCirc,
        height: 60.0,
        items: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  blurRadius: 8,
                  offset: -Offset(4, 4),
                  color: Colors.black.mix(Colors.white, 0.5)!,
                ),
                BoxShadow(
                  blurRadius: 8,
                  offset: Offset(4, 4),
                  color: Colors.black.mix(Colors.brown, 0.7)!,
                )
              ],
            ),
            child: Icon(
              LineIcons.phone,
              color: Colors.white,
            ),
          ), // TODO add flutter_neumorphic package
          Icon(
            LineIcons.circle,
            color: Colors.white,
          ),
          Icon(
            LineIcons.alternateCommentAlt,
            color: Colors.white,
          ),
        ],
      ),
      body: pages[_page],
    );
  }
}

extension ColorUtils on Color {
  Color? mix(Color? another, double amount) {
    return Color.lerp(this, another, amount);
  }
}
