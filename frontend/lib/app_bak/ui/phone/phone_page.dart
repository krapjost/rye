import 'dart:core';

import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class PhonePage extends StatefulWidget {
  const PhonePage({Key? key}) : super(key: key);

  @override
  PhonePageState createState() => PhonePageState();
}

class PhonePageState extends State<PhonePage> {
  int _page = 0;
  List<dynamic>? cameras;
  List<Widget> _pressedDialButtons = [SizedBox()];
  final _pageViewController = PageController();

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double iconSize = deviceWidth > 425 ? 42.5 : deviceWidth / 13;

    List<Widget> topicButtons = [
      Icon(
        LineIcons.book,
        size: iconSize,
        color: Colors.white,
      ),
      Icon(
        LineIcons.dna,
        size: iconSize,
        color: Colors.white,
      ),
      Icon(
        LineIcons.film,
        size: iconSize,
        color: Colors.white,
      ),
      Icon(
        LineIcons.bicycle,
        size: iconSize,
        color: Colors.white,
      ),
      Icon(
        LineIcons.heart,
        size: iconSize,
        color: Colors.white,
      ),
      Icon(
        LineIcons.gamepad,
        size: iconSize,
        color: Colors.white,
      ),
      Icon(
        LineIcons.music,
        size: iconSize,
        color: Colors.white,
      ),
      Icon(
        LineIcons.circle,
        size: iconSize,
        color: Colors.white38,
      ),
      Icon(
        LineIcons.circle,
        size: iconSize,
        color: Colors.white38,
      ),
      Icon(
        LineIcons.random,
        size: iconSize * 0.7,
        color: Colors.brown.shade400,
      ),
      Icon(
        LineIcons.circle,
        size: iconSize,
        color: Colors.white38,
      ),
      Icon(
        LineIcons.hashtag,
        size: iconSize * 0.7,
        color: Colors.brown.shade400,
      ),
    ];

    Widget dialButtonGrid = ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 300,
        maxHeight: 340,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: 12,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1 / 0.8,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Ink(
            padding: EdgeInsets.all(3),
            height: 28,
            width: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ), // LinearGradientBoxDecoration
            child: InkWell(
              highlightColor: Colors.white,
              onTap: () {
                if (mounted)
                  setState(() {
                    _pressedDialButtons.add(topicButtons[index]);
                  });
              },
              onLongPress: () {
                /* Get.defaultDialog( */
                /*   radius: 10, */
                /*   content: Text( */
                /*       "There is no topic assigned to this dial button", */
                /*       style: TextStyle(color: Colors.white, fontSize: 18)), */
                /*   contentPadding: EdgeInsets.all(21), */
                /*   title: "Assign topic?", */
                /*   titleStyle: TextStyle(color: Colors.white, fontSize: 28), */
                /*   titlePadding: EdgeInsets.fromLTRB(21, 21, 21, 0), */
                /*   backgroundColor: Colors.grey.shade900, */
                /*   confirm: TextButton( */
                /*     style: ButtonStyle( */
                /*         fixedSize: MaterialStateProperty.all( */
                /*             Size.fromWidth(Get.width * 0.3)), */
                /*         padding: MaterialStateProperty.all(EdgeInsets.all(13)), */
                /*         backgroundColor: MaterialStateProperty.all( */
                /*           Colors.black, */
                /*         )), */
                /*     onPressed: () { */
                /*       print('confirm'); */
                /*     }, */
                /*     child: Text( */
                /*       "Confirm", */
                /*       style: TextStyle(color: Colors.brown, fontSize: 18), */
                /*     ), */
                /*   ), */
                /*   cancel: TextButton( */
                /*     style: ButtonStyle( */
                /*         fixedSize: MaterialStateProperty.all( */
                /*             Size.fromWidth(Get.width * 0.3)), */
                /*         padding: MaterialStateProperty.all(EdgeInsets.all(13)), */
                /*         backgroundColor: MaterialStateProperty.all( */
                /*             Colors.black.withOpacity(0.1))), */
                /*     onPressed: () { */
                /*       Get.back(); */
                /*     }, */
                /*     child: Text( */
                /*       "Cancel", */
                /*       style: TextStyle(color: Colors.brown, fontSize: 18), */
                /*     ), */
                /*   ), */
                /* ); */
                print("add topic");
              },
              customBorder: CircleBorder(),
              child: topicButtons[index],
            ),
          );
        },
      ),
    );

    Widget interactionButtonRow = buildConstrainedBox(context);

    Widget pressedDialButtonRow = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 300),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _pressedDialButtons,
        ),
      ),
    );

    Widget dialTapView = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          pressedDialButtonRow,
          SizedBox(height: 30),
          dialButtonGrid,
          interactionButtonRow,
          SizedBox(height: 30),
        ],
      ),
    );

    var pages = [
      dialTapView,
      Center(
        child: Text(
          "topic list view",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      Center(
        child: Text(
          "VoiceMail",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      )
    ];
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        backgroundColor: Colors.transparent,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.brown,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          _pageViewController.animateToPage(index,
              duration: Duration(milliseconds: 200), curve: Curves.bounceOut);
        },
        items: [
          BottomNavigationBarItem(
              tooltip: "call", label: "call", icon: Icon(LineIcons.braille)),
          BottomNavigationBarItem(
              tooltip: "topic",
              label: "topic",
              icon: Icon(LineIcons.quoteLeft)),
          BottomNavigationBarItem(
              tooltip: "voicemail",
              label: "voicemail",
              icon: Icon(LineIcons.voicemail)),
        ],
      ),
      body: PageView.builder(
        controller: _pageViewController,
        itemBuilder: (BuildContext context, int index) {
          return pages[index % pages.length];
        },
        onPageChanged: (index) {
          setState(() {
            _page = index % pages.length;
          });
        },
      ),
    );
  }

  ConstrainedBox buildConstrainedBox(BuildContext context) {
    var width = MediaQuery.of(context).size.width * 0.8;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 300),
      child: Container(
        width: width,
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 60,
              height: 60,
            ),
            Ink(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.brown.shade800,
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  onTap: () {
                    print('to call page');
                  },
                  customBorder: CircleBorder(),
                  child: Icon(LineIcons.phone, color: Colors.white, size: 34),
                )),
            _pressedDialButtons.length > 1
                ? Ink(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ), // LinearGradientBoxDecoration
                    child: InkWell(
                      onTap: () {
                        if (mounted)
                          setState(() {
                            _pressedDialButtons.removeLast();
                          });
                      },
                      onLongPress: () {
                        if (mounted)
                          setState(() {
                            _pressedDialButtons.clear();
                            _pressedDialButtons.add(SizedBox());
                          });
                      },
                      customBorder: CircleBorder(
                          side: BorderSide(
                              width: 2,
                              color: Colors.white,
                              style: BorderStyle.solid)),
                      child:
                          Icon(LineIcons.times, color: Colors.white, size: 20),
                    ),
                  )
                : SizedBox(width: 60, height: 60),
          ],
        ),
      ),
    );
  }
}

double convertZeroToOneScale(double number, double max) {
  double toConvert = number.abs() > max ? max : number.abs();
  return toConvert / max;
}

int maxToHex(double number) => number > 255 ? 255 : number.toInt();
