import 'dart:async';
import 'dart:html' as html;

import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:line_icons/line_icons.dart';

class WebCameraPage extends StatefulWidget {
  const WebCameraPage({Key? key}) : super(key: key);

  @override
  WebCameraPageState createState() => WebCameraPageState();
}

class WebCameraPageState extends State<WebCameraPage> {
  MediaStream? _localStream;
  MediaRecorder? _mediaRecorder;
  final _localRenderer = RTCVideoRenderer();
  bool _inCalling = false;
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

    return Text("d");
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
