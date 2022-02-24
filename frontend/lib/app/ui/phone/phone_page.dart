import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:line_icons/line_icons.dart';

class PhonePage extends StatefulWidget {
  const PhonePage({Key? key}) : super(key: key);

  @override
  PhonePageState createState() => PhonePageState();
}

class PhonePageState extends State<PhonePage> {
  MediaStream? _localStream;
  final _localRenderer = RTCVideoRenderer();
  bool _inCalling = false;
  List<dynamic>? cameras;
  List<Widget> _pressedDialButtons = [SizedBox()];

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
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LineIcons.faceBlowingAKiss,
            size: iconSize,
            color: Colors.white,
          ),
          SizedBox(height: 5),
          Text(
            "love",
            style: TextStyle(
              color: Colors.white54,
            ),
          ),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LineIcons.splotch,
            size: iconSize,
            color: Colors.white,
          ),
          SizedBox(height: 5),
          Text(
            "winter",
            style: TextStyle(
              color: Colors.white54,
            ),
          ),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LineIcons.userAstronaut,
            size: iconSize,
            color: Colors.white,
          ),
          SizedBox(height: 5),
          Text(
            "space",
            style: TextStyle(
              color: Colors.white54,
            ),
          ),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LineIcons.snowflakeAlt,
            size: iconSize,
            color: Colors.white,
          ),
          SizedBox(height: 5),
          Text(
            "winter",
            style: TextStyle(
              color: Colors.white54,
            ),
          ),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LineIcons.timesCircleAlt,
            size: iconSize,
            color: Colors.white,
          ),
          SizedBox(height: 5),
          Text(
            "winter",
            style: TextStyle(
              color: Colors.white54,
            ),
          ),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LineIcons.egg,
            size: iconSize,
            color: Colors.white,
          ),
          SizedBox(height: 5),
          Text(
            "winter",
            style: TextStyle(
              color: Colors.white54,
            ),
          ),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LineIcons.smilingFaceAlt,
            size: iconSize,
            color: Colors.white,
          ),
          SizedBox(height: 5),
          Text(
            "winter",
            style: TextStyle(
              color: Colors.white54,
            ),
          ),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LineIcons.gitAlt,
            size: iconSize,
            color: Colors.white,
          ),
          SizedBox(height: 5),
          Text(
            "winter",
            style: TextStyle(
              color: Colors.white54,
            ),
          ),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LineIcons.earlybirds,
            size: iconSize,
            color: Colors.white,
          ),
          SizedBox(height: 5),
          Text(
            "winter",
            style: TextStyle(
              color: Colors.white54,
            ),
          ),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LineIcons.materialDesignForBootstrap,
            size: iconSize,
            color: Colors.white,
          ),
          SizedBox(height: 5),
          Text(
            "Any topic",
            style: TextStyle(
              color: Colors.white54,
            ),
          ),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LineIcons.audioFileAlt,
            size: iconSize,
            color: Colors.white,
          ),
          SizedBox(height: 5),
          Text(
            "Music",
            style: TextStyle(
              color: Colors.white54,
            ),
          ),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LineIcons.snowflakeAlt,
            size: iconSize,
            color: Colors.white,
          ),
          SizedBox(height: 5),
          Text(
            "winter",
            style: TextStyle(
              color: Colors.white54,
            ),
          ),
        ],
      ),
    ];

    Widget dialButtonGrid = ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 300,
        maxHeight: 400,
      ),
      child: Container(
        width: deviceWidth * 0.8,
        child: Center(
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: 12,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1 / 0.9,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (BuildContext context, int index) {
              return Ink(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black],
                  ),
                ), // LinearGradientBoxDecoration
                child: InkWell(
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

    Widget interactionButtonRow = Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(width: 60),
          CircleAvatar(
              radius: 30,
              backgroundColor: Colors.brown,
              child: IconButton(
                onPressed: _inCalling ? _hangUp : _makeCall,
                tooltip: _inCalling ? 'Hangup' : 'Call',
                icon: Icon(_inCalling ? LineIcons.phoneSlash : LineIcons.phone),
                iconSize: 35,
                color: Colors.white,
              )),
          _pressedDialButtons.length > 1
              ? Ink(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.red.withOpacity(0.3), Colors.brown],
                    ),
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
                    customBorder: CircleBorder(),
                    child: Icon(LineIcons.times, color: Colors.white, size: 20),
                  ),
                )
              : SizedBox(width: 60),
        ],
      ),
    );

    Widget pressedDialButtonRow = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: deviceWidth * 0.8),
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
          dialButtonGrid,
          interactionButtonRow,
        ],
      ),
    );

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: TabBar(
          indicatorColor: Colors.brown,
          tabs: [
            Tab(icon: Icon(LineIcons.tty)),
            Tab(icon: Icon(LineIcons.addressCardAlt)),
            Tab(icon: Icon(LineIcons.voicemail)),
          ],
        ),
        body: TabBarView(
          children: [
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
