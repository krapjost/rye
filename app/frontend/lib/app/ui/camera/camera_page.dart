import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
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

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  StreamController<String> _streamController = StreamController<String>();
  List<CameraDescription>? _cameras;
  bool _isRecording = false;

  @override
  void initState() {
    _initCamera();
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras![0], ResolutionPreset.low);

    _controller!.initialize().then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (_controller == null || !_controller!.value.isInitialized) {
      return Scaffold(
        body: Center(
          child: SizedBox(
            width: 32,
            height: 32,
            child: SpinKitPulse(color: Palette.RYE, size: 100.0),
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Container(
          color: Colors.blue,
          height: size.height,
          width: size.width,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              _buildCameraPreview(),
              Positioned(
                bottom: 100.0,
                right: 15.0,
                child: IconButton(
                  icon: Icon(
                    Icons.switch_camera,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _onCameraSwitch();
                  },
                ),
              ),
              Positioned(
                bottom: 100.0,
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      (_isRecording) ? LineIcons.squareAlt : LineIcons.circle,
                      size: 32.0,
                      color: _isRecording ? Colors.red : Colors.black,
                    ),
                    onPressed: () {
                      if (_isRecording) {
                        stopVideoRecording();
                      } else {
                        startVideoRecording();
                      }
                    },
                  ),
                ),
              ),
              bottomNavBar(context, 0),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildCameraPreview() {
    final size = MediaQuery.of(context).size;
    final deviceRatio;

    if (size.width > 1024) {
      deviceRatio = size.height / size.width;
    } else {
      deviceRatio = size.width / size.height;
    }

    return Stack(
      children: [
        Container(
          width: size.width,
          child: ClipRect(
            child: AspectRatio(
              aspectRatio: deviceRatio,
              child: CameraPreview(_controller!),
            ),
          ),
        ),
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.blue.withOpacity(0.5)),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _onCameraSwitch() async {
    final CameraDescription cameraDescription =
        (_controller!.description == _cameras![0])
            ? _cameras![1]
            : _cameras![0];
    if (_controller != null) {
      await _controller?.dispose();
    }
    _controller = CameraController(cameraDescription, ResolutionPreset.medium);
    _controller!.addListener(() {
      if (mounted) setState(() {});
      if (_controller!.value.hasError) {
        showInSnackBar('Camera error ${_controller!.value.errorDescription}');
      }
    });
    try {
      await _controller!.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<String> startVideoRecording() async {
    print('startVideoRecording');
    String filePath = '';
    if (_controller!.value.isInitialized) {
      if (mounted)
        setState(() {
          _isRecording = true;
        });

      if (kIsWeb) {
        filePath = 'temp/${_timestamp()}.mp4';
      } else {
        try {
          final Directory extDir = await getTemporaryDirectory();
          print('ext Dir is $extDir');
          final String dirPath = '${extDir.path}/media';
          print('dir path is $dirPath');
          await Directory(dirPath).create(recursive: true);
          filePath = '$dirPath/${_timestamp()}.mp4';
          print('filepath to upload is $filePath');
        } catch (e) {
          print('error occured while get path ${e}');
        }
      }
    }
    if (!_controller!.value.isRecordingVideo) {
      try {
        await _controller!.startVideoRecording();
      } on CameraException catch (e) {
        _showCameraException(e);
      }
    }
    return filePath;
  }

  Future<void> stopVideoRecording() async {
    print('pressed stop recording');
    if (_controller!.value.isRecordingVideo) {
      if (mounted)
        setState(() {
          _isRecording = false;
        });

      try {
        XFile? video = await _controller!.stopVideoRecording();
        print('video is $video');
        uploadFeed(video);
      } on CameraException catch (e) {
        _showCameraException(e);
      }
    }
  }

  Future<void> uploadFeed(XFile _video) async {
    _streamController.add('시작');
    String userId = AuthProvider.getUid();

    DateTime createdAt = DateTime.now();
    String storagePath = '$userId/${createdAt.toString()}/${_video.name}';

    try {
      await StorageProvider.putMedia(_video, userId, storagePath);
    } catch (e) {
      print('upload error $e');
    }

    String _url = await StorageProvider.fetchMediaUrl(storagePath);

    FeedModel feedModel = FeedModel(
        description: "",
        url: _url,
        created_at: createdAt,
        owner: 'sad',
        likes: 0);

    bool isTapeCreated = await TapeProvider.isCreated('sad', userId);
    if (!isTapeCreated) {
      TapeModel tapeModel = TapeModel(
        tag: 'sad',
        created_at: createdAt.toString(),
        owner: userId,
      );
      TapeProvider.addTape(tapeModel);
    }

    FeedProvider.addFeed(feedModel);

    _streamController.add('완료');
    Get.offAllNamed('/profile');
    Get.snackbar('업로드 완료', '소중한 순간을 안전하게 저장했습니다.');
  }
}

String _timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

void _showCameraException(CameraException e) {
  logError(e.code, e.description!);
  Get.snackbar('Error', '${e.code}\n ${e.description}');
}

void showInSnackBar(String message) {
  Get.snackbar('카메라', message);
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

@override
bool get wantKeepAlive => true;
