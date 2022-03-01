import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class PhonePage extends StatefulWidget {
  const PhonePage({Key? key}) : super(key: key);

  @override
  PhonePageState createState() => PhonePageState();
}

class PhonePageState extends State<PhonePage> {
  MediaStream? _localStream;
  final _localRenderer = RTCVideoRenderer();
  bool _inCalling = false;
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
  void initState() {
    super.initState();
    initRenderers();

    navigator.mediaDevices.enumerateDevices().then((md) {
      setState(() {
        cameras = md.where((d) => d.kind == 'videoinput').toList();
      });
    });
  }

  @override
  void deactivate() {
    super.deactivate();
    if (_inCalling) {
      _stop();
    }
    _localRenderer.dispose();
  }

  void initRenderers() async {
    await _localRenderer.initialize();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void _makeCall() async {
    final mediaConstraints = <String, dynamic>{
      'audio': true,
      'video': {
        'mandatory': {
          'minWidth':
              '1280', // Provide your own width, height and frame rate here
          'minHeight': '720',
          'minFrameRate': '30',
        },
      }
    };

    try {
      var stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      _localStream = stream;
      _localRenderer.srcObject = _localStream;
    } catch (e) {
      print(e.toString());
    }
    if (!mounted) return;

    setState(() {
      _inCalling = true;
    });
  }

  Future<void> _stop() async {
    try {
      if (kIsWeb) {
        _localStream?.getTracks().forEach((track) => track.stop());
      }
      await _localStream?.dispose();
      _localStream = null;
      _localRenderer.srcObject = null;
    } catch (e) {
      print(e.toString());
    }
  }

  void _hangUp() async {
    await _stop();
    setState(() {
      _inCalling = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double iconSize = deviceWidth > 425 ? 42.5 : deviceWidth / 10;

    List<Widget> topicButtons = [
      Icon(
        LineIcons.faceBlowingAKiss,
        size: iconSize,
        color: Colors.white,
      ),
      Icon(
        LineIcons.splotch,
        size: iconSize,
        color: Colors.white,
      ),
      Icon(
        LineIcons.userAstronaut,
        size: iconSize,
        color: Colors.white,
      ),
      Icon(
        LineIcons.snowflakeAlt,
        size: iconSize,
        color: Colors.white,
      ),
      Icon(
        LineIcons.timesCircleAlt,
        size: iconSize,
        color: Colors.white,
      ),
      Icon(
        LineIcons.egg,
        size: iconSize,
        color: Colors.white,
      ),
      Icon(
        LineIcons.smilingFaceAlt,
        size: iconSize,
        color: Colors.white,
      ),
      Icon(
        LineIcons.gitAlt,
        size: iconSize,
        color: Colors.white,
      ),
      Icon(
        LineIcons.earlybirds,
        size: iconSize,
        color: Colors.white,
      ),
      Icon(
        LineIcons.asterisk,
        size: iconSize * 0.7,
        color: Colors.white,
      ),
      Icon(
        LineIcons.audioFileAlt,
        size: iconSize,
        color: Colors.white,
      ),
      Icon(
        LineIcons.hashtag,
        size: iconSize * 0.7,
        color: Colors.white,
      ),
    ];

    Widget dialButtonGrid = ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 300,
        maxHeight: 340,
      ),
      child: Container(
        width: deviceWidth * 0.8,
        child: Center(
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: 12,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1 / 0.8,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (BuildContext context, int index) {
              return Ink(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.2),
                      Colors.white.withOpacity(0.1)
                    ],
                  ),
                ), // LinearGradientBoxDecoration
                child: InkWell(
                  highlightColor: Colors.white,
                  onTap: () {
                    print("pressed $index");
                    if (mounted)
                      setState(() {
                        _pressedDialButtons.add(topicButtons[index]);
                      });
                  },
                  customBorder: CircleBorder(),
                  child: topicButtons[index],
                ),
              );
            },
          ),
        ),
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
          SizedBox(height: 60),
        ],
      ),
    );

    var pages = [
      dialTapView,
      Center(
        child: Text(
          "Address",
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
              tooltip: "call", label: "call", icon: Icon(LineIcons.tty)),
          BottomNavigationBarItem(
              tooltip: "address",
              label: "address",
              icon: Icon(LineIcons.addressCardAlt)),
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
                  border: Border.all(width: 2, color: Colors.white),
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  onTap: _inCalling ? _hangUp : _makeCall,
                  customBorder: CircleBorder(),
                  child: Icon(
                      _inCalling ? LineIcons.phoneSlash : LineIcons.phone,
                      color: Colors.white,
                      size: 34),
                )),
            _pressedDialButtons.length > 1
                ? Ink(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.white),
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
