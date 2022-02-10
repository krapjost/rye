import 'dart:async';
import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:microphone/microphone.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rye/app/data/model/feedModel.dart';
import 'package:rye/app/data/model/tapeModel.dart';
import 'package:rye/app/data/provider/auth.dart';
import 'package:rye/app/data/provider/firestore.dart';
import 'package:rye/app/data/provider/storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rye/app/ui/theme/app_colors.dart';
import 'package:rye/app/ui/widgets/bottom_navigation_widget.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:get/get.dart';
import 'package:flutter/services.dart';

class WebCameraPage extends StatefulWidget {
  const WebCameraPage({Key? key}) : super(key: key);

  @override
  WebCameraPageState createState() => WebCameraPageState();
}

class WebCameraPageState extends State<WebCameraPage> {
  MicrophoneRecorder? _recorder;
  AudioPlayer? _audioPlayer;

  bool _isRecording = false;
  bool _isUploading = false;
  bool _pressStarted = false;
  Offset _tapLocation = Offset(0, 0);
  Offset _distanceFromTapStart = Offset(0, 0);

  Color _angryColor = Color.fromRGBO(0, 0, 0, 0);
  Color _happyColor = Color.fromRGBO(0, 0, 0, 0);
  Color _sadColor = Color.fromRGBO(0, 0, 0, 0);
  Color _nervColor = Color.fromRGBO(0, 0, 0, 0);

  @override
  void initState() {
    _initRecorder();
    super.initState();
  }

  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> _initRecorder() async {
    _recorder?.dispose();

    _recorder = MicrophoneRecorder()
      ..init()
      ..addListener(() {
        if (mounted) setState(() {});
      });
  }

  Future<html.MediaStream?> getMediaStream() async {
    try {
      return await html.window.navigator.mediaDevices!.getUserMedia({
        "audio": true,
      });
    } catch (e) {
      print('error on get Media $e');
    }
  }

  @override
  void dispose() {
    _recorder?.dispose();
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recorderState = _recorder!.value;

    final size = MediaQuery.of(context).size;
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

    List<Widget> content;
    if (_isUploading) {
      content = [
        Center(
          child: SizedBox(
            width: 32,
            height: 32,
            child: SpinKitPulse(color: Palette.RYE, size: 100.0),
          ),
        ),
        bottomNavBar(context, 0),
      ];
    } else {
      if (recorderState.started) {
        if (recorderState.stopped) {
          content = [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {
                    setState(_initRecorder);
                  },
                  child: Text('Restart recorder'),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                  ),
                  child: OutlinedButton(
                    onPressed: () async {
                      _audioPlayer?.dispose();

                      _audioPlayer = AudioPlayer();

                      await _audioPlayer!.setUrl(recorderState.recording!.url);
                      await _audioPlayer!.play();
                      setState(() {});

                      print("audio player ${_audioPlayer!.playing}");
                    },
                    child: Text('Play recording'),
                  ),
                ),
              ],
            )
          ];
        } else {
          content = [
            OutlinedButton(
              onPressed: () {
                _recorder!.stop();
              },
              child: Text('Stop recording'),
            )
          ];
        }
      } else {
        content = <Widget>[
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

              print(faceSizes);

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

              if (!recorderState.started) {
                _recorder!.start();
              }

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
          bottomNavBar(context, 0),
        ];
      }
    }

    return Scaffold(
      body: Container(
        color: Colors.black,
        height: size.height,
        width: size.width,
        child: Stack(
          alignment: Alignment.center,
          children: content,
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
