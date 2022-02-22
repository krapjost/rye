import 'dart:async';
import 'dart:html' as html;
import 'dart:ui' as ui;

import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:line_icons/line_icons.dart';

import 'package:rye/app/ui/widgets/bottom_navigation_widget.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

class WebCameraPage extends StatefulWidget {
  const WebCameraPage({Key? key}) : super(key: key);

  @override
  WebCameraPageState createState() => WebCameraPageState();
}

class WebCameraPageState extends State<WebCameraPage> {
  MediaStream? _localStream;
  final _localRenderer = RTCVideoRenderer();
  bool _inCalling = false;
  MediaRecorder? _mediaRecorder;
  List<MediaDeviceInfo>? _cameras;
  bool get _isRec => _mediaRecorder != null;
  List<dynamic>? cameras;

  bool _pressStarted = false;
  Offset _tapLocation = Offset(0, 0);
  Offset _distanceFromTapStart = Offset(0, 0);

  Color _angryColor = Color.fromRGBO(0, 0, 0, 0);
  Color _happyColor = Color.fromRGBO(0, 0, 0, 0);
  Color _sadColor = Color.fromRGBO(0, 0, 0, 0);
  Color _nervColor = Color.fromRGBO(0, 0, 0, 0);

  double _faceIconSize = 45;
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
      _cameras = await Helper.cameras;
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

  void _startRecording() async {
    if (_localStream == null) throw Exception('Can\'t record without a stream');
    _mediaRecorder = MediaRecorder();
    setState(() {});
    _mediaRecorder?.startWeb(_localStream!);
  }

  void _stopRecording() async {
    final objectUrl = await _mediaRecorder?.stop();
    setState(() {
      _mediaRecorder = null;
    });
    print(objectUrl);
    // ignore: unsafe_html
    html.window.open(objectUrl, '_blank');
  }

  void _captureFrame() async {
    if (_localStream == null) throw Exception('Can\'t record without a stream');
    final videoTrack = _localStream!
        .getVideoTracks()
        .firstWhere((track) => track.kind == 'video');
    final frame = await videoTrack.captureFrame();
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content:
                  Image.memory(frame.asUint8List(), height: 720, width: 1280),
              actions: <Widget>[
                TextButton(
                  onPressed: Navigator.of(context, rootNavigator: true).pop,
                  child: Text('OK'),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // left, bottom
    final List<double> faceButtonLocation = [
      size.width / 2 - (_faceIconSize / 2),
      70
    ];

    /**
    final double initialFaceSize = 0;
    final double cryingFaceSize = _distanceFromTapStart.dy > initialFaceSize
        ? _distanceFromTapStart.dy * 2
        : initialFaceSize;
    final double smilingFaceSize = _distanceFromTapStart.dy < -initialFaceSize
        ? _distanceFromTapStart.dy * -2
        : initialFaceSize;
    final double angryFaceSize = _distanceFromTapStart.dx > initialFaceSize
        ? _distanceFromTapStart.dx * 2
        : initialFaceSize;
    final double nervousFaceSize = _distanceFromTapStart.dx < -initialFaceSize
        ? _distanceFromTapStart.dx * -2
        : initialFaceSize;
        **/

    List<Icon> faceIcons = [
      Icon(LineIcons.faceBlowingAKiss),
      Icon(LineIcons.faceWithTongue),
      Icon(LineIcons.angryFace),
      Icon(LineIcons.cryingFace),
      Icon(LineIcons.smilingFace),
      Icon(LineIcons.faceWithTearsOfJoy),
      Icon(LineIcons.faceWithRollingEyes),
      Icon(LineIcons.frowningFaceWithOpenMouth),
      Icon(LineIcons.grinningFaceWithBigEyes),
      Icon(LineIcons.asterisk),
      Icon(LineIcons.faceWithoutMouth),
      Icon(LineIcons.hashtag),
    ];

    Widget faceDial = GridView.builder(
      itemCount: 12, //item 개수
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, //1 개의 행에 보여줄 item 개수
        childAspectRatio: 1 / 1, //item 의 가로 1, 세로 2 의 비율
      ),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: IconButton(
            onPressed: () {
              print("pressed");
            },
            color: Colors.white,
            icon: faceIcons[index],
            iconSize: _faceIconSize,
          ),
        );
      }, //item 의 반목문 항목 형성
    );

    final List<Widget> emotionIconButtons = [
      Center(
        child: Container(
          margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: Colors.black54),
          child: RTCVideoView(_localRenderer, mirror: true),
        ),
      ),

      /**
      GestureDetector(
        onLongPressDown: (detail) {
          print("longpressDown ${detail.globalPosition}");
          _tapLocation = detail.globalPosition;
          if (mounted) setState(() {});
        },
        onLongPressStart: (detail) {
          print("longpressStart ${detail.globalPosition}");
          _pressStarted = true;
          if (mounted) setState(() {});
        },
        onLongPressUp: () {
          print("longpress up");
          _tapLocation = Offset(-100, -100);
          _distanceFromTapStart = Offset(0, 0);
          if (mounted) setState(() {});
        },
        onLongPressCancel: () {
          print("longpress canceled");
          _tapLocation = Offset(-100, -100);
          _distanceFromTapStart = Offset(0, 0);
          if (mounted) setState(() {});
        },
        onLongPressMoveUpdate: (detail) {
          _distanceFromTapStart = detail.offsetFromOrigin;
          Map<String, int> faceSizes = {
            "sad": maxToHex(cryingFaceSize.abs()),
            "happy": maxToHex(smilingFaceSize.abs()),
            "angry": maxToHex(angryFaceSize.abs()),
            "nerv": maxToHex(nervousFaceSize.abs())
          };
          _angryColor = Color.fromRGBO(faceSizes["angry"]!, 0, 0, 0.5);
          _sadColor = Color.fromRGBO(0, 0, faceSizes["sad"]!, 0.5);
          _nervColor = Color.fromRGBO(
              0, faceSizes["nerv"]! ~/ 2, faceSizes["nerv"]! ~/ 2, 0.5);
          _happyColor = Color.fromRGBO(0, faceSizes["happy"]!, 0, 0.5);
          if (mounted) setState(() {});
        },
        onLongPressEnd: (detail) {
          print("longpress End ${detail.globalPosition}");
          _pressStarted = false;
          _distanceFromTapStart = Offset(0, 0);
          if (mounted) setState(() {});
        },
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 20),
          child: Stack(
            children: [
              Container(
                color: _angryColor,
              ),
              Container(
                color: _sadColor,
              ),
              Container(
                color: _happyColor,
              ),
              Container(
                color: _nervColor,
              ),
            ],
          ),
        ),
      ),
      Positioned(
        top: size.height / 2 - smilingFaceSize + (smilingFaceSize / 2),
        left: size.width / 2 - smilingFaceSize / 2,
        child: Icon(
          LineIcons.smilingFace,
          size: smilingFaceSize,
          color: Colors.white
              .withOpacity(convertZeroToOneScale(smilingFaceSize, 100)),
        ),
      ),
      Positioned(
        top: size.height / 2 - cryingFaceSize + (cryingFaceSize / 2),
        left: size.width / 2 - cryingFaceSize / 2,
        child: Icon(
          LineIcons.cryingFace,
          size: cryingFaceSize,
          color: Colors.white
              .withOpacity(convertZeroToOneScale(cryingFaceSize, 100)),
        ),
      ),
      Positioned(
        top: size.height / 2 - angryFaceSize / 2,
        left: size.width / 2 - angryFaceSize + (angryFaceSize / 2),
        child: Icon(
          LineIcons.angryFace,
          size: angryFaceSize,
          color: Colors.white
              .withOpacity(convertZeroToOneScale(angryFaceSize, 100)),
        ),
      ),
      Positioned(
        top: size.height / 2 - nervousFaceSize / 2,
        left: size.width / 2 - nervousFaceSize + (nervousFaceSize / 2),
        child: Icon(
          LineIcons.faceWithTongue,
          size: nervousFaceSize,
          color: Colors.white
              .withOpacity(convertZeroToOneScale(nervousFaceSize, 100)),
        ),
      ),
      **/

      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 90 * 3,
              maxHeight: 90 * 4,
            ),
            child: Container(
              child: faceDial,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    onPressed: () {
                      print('ddd');
                      if (mounted)
                        setState(() {
                          _faceIconSize = 30;
                        });
                    },
                    icon: Icon(LineIcons.phoneSlash),
                    iconSize: _faceIconSize,
                    color: Colors.white,
                  )),
            ],
          ),
          SizedBox(
            height: 80,
          ),
        ],
      ),
      bottomNavBar(context, 0),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: emotionIconButtons,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _inCalling ? _hangUp : _makeCall,
        tooltip: _inCalling ? 'Hangup' : 'Call',
        child: Icon(_inCalling ? Icons.call_end : Icons.phone),
      ),
    );
  }

  void _switchCamera(String deviceId) async {
    if (_localStream == null) return;

    await Helper.switchCamera(
        _localStream!.getVideoTracks()[0], deviceId, _localStream);
    setState(() {});
  }
}

double convertZeroToOneScale(double number, double max) {
  double toConvert = number.abs() > max ? max : number.abs();
  return toConvert / max;
}

int maxToHex(double number) => number > 255 ? 255 : number.toInt();
