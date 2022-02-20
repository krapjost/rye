import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:camera_web/camera_web.dart';
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
  List<CameraDescription>? _cameras;
  bool _isRecording = false;
  bool _isUploading = false;
  bool _pressStarted = false;
  Offset _tapLocation = Offset(0, 0);
  Offset _distanceFromTapStart = Offset(0, 0);
  Color _emotionColor = Color.fromRGBO(0, 0, 0, 0.7);
  CameraPlugin? _webCamera;

  @override
  void initState() {
    _initCamera();
    super.initState();
  }

  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
    } catch (e) {
      Get.snackbar("get camera error", "${e}");
    }
    Get.snackbar("first camera", "${_cameras![0]}");
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
    final double initialFaceSize = 0;
    final double cryingFaceSize = _distanceFromTapStart.dy > initialFaceSize
        ? _distanceFromTapStart.dy
        : initialFaceSize;
    final double smilingFaceSize = _distanceFromTapStart.dy < -initialFaceSize
        ? _distanceFromTapStart.dy * -1
        : initialFaceSize;

    final double angryFaceSize = _distanceFromTapStart.dx > initialFaceSize
        ? _distanceFromTapStart.dx
        : initialFaceSize;
    final double nervousFaceSize = _distanceFromTapStart.dx < -initialFaceSize
        ? _distanceFromTapStart.dx * -1
        : initialFaceSize;

    List<double> faceSizes = [
      cryingFaceSize,
      smilingFaceSize,
      angryFaceSize,
      nervousFaceSize
    ];

    List<Widget> content;
    if (_isUploading ||
        _controller == null ||
        !_controller!.value.isInitialized) {
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
            if (mounted) setState(() {});
            print("distance from tap strat ${_distanceFromTapStart}");
          },
          onLongPressEnd: (detail) {
            print("longpress End ${detail.globalPosition}");
            _pressStarted = false;
            _distanceFromTapStart = Offset(0, 0);
            if (mounted) setState(() {});
          },
          child: _buildCameraPreview(),
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

  Widget _buildCameraPreview() {
    final size = MediaQuery.of(context).size;
    final deviceRatio;

    if (size.width > 1024) {
      deviceRatio = size.height / size.width;
    } else {
      deviceRatio = size.width / size.height;
    }

    return Container(
      width: size.width,
      height: size.height,
      child: AspectRatio(
        aspectRatio: deviceRatio,
        child: CameraPreview(
          _controller!,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 20),
            child: Container(
              color: _emotionColor,
            ),
          ),
        ),
        // Image.network("https://i.imgur.com/7FUE5c1.jpeg"),
      ),
    );
  }

  Future<String> getTemporaryFilePathOnDevice() async {
    String filePath = '';
    try {
      final Directory extDir = await getTemporaryDirectory();
      print('!!!!! ext Dir is $extDir');
      final String dirPath = '${extDir.path}/media';
      print('dir path is $dirPath');
      await Directory(dirPath).create(recursive: true);
      filePath = '$dirPath/${_timestamp()}.mp4';
      print('filepath to upload is $filePath');
    } catch (e) {
      print('error occured while get path ${e}');
    }
    return filePath;
  }

  Future<String> startVideoRecording() async {
    String filePath = kIsWeb
        ? 'temp/${_timestamp()}.mp4'
        : await getTemporaryFilePathOnDevice();
    print("### filepath is $filePath");
    if (_controller!.value.isInitialized &&
        !_controller!.value.isRecordingVideo) {
      try {
        await _controller!.startVideoRecording();
        if (mounted)
          setState(() {
            _isRecording = true;
          });
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
        XFile? thumbnail = await _controller!.takePicture();
        XFile? video = await _controller!.stopVideoRecording();
        print("thumbnail is $thumbnail");
        print('video is $video');
        uploadFeed(video, thumbnail);
      } on CameraException catch (e) {
        _showCameraException(e);
      }
    }
  }

  Future<void> uploadFeed(XFile _video, XFile _thumbnail) async {
    _isUploading = true;
    if (mounted) setState(() {});
    String userId = AuthProvider.getUid();
    DateTime createdAt = DateTime.now();

    String videoStoragePath = '$userId/${createdAt.toString()}/${_video.name}';
    String thumbnailStoragePath =
        '$userId/${createdAt.toString()}/thumbnail_${_video.name}';

    try {
      await StorageProvider.putMedia(_video, videoStoragePath);
      await StorageProvider.putMedia(_thumbnail, thumbnailStoragePath);
    } catch (e) {
      print('Error :\n camera page \n uploadFeed \n $e');
    }

    String _video_url = await StorageProvider.fetchMediaUrl(videoStoragePath);
    String _thumbnail_url =
        await StorageProvider.fetchMediaUrl(thumbnailStoragePath);

    FeedModel feedModel = FeedModel(
        description: "",
        video_url: _video_url,
        thumbnail_url: _thumbnail_url,
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

    _isUploading = false;
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

double convertZeroToOneScale(double number, double max) {
  double toConvert = number.abs() > max ? max : number.abs();
  return toConvert / max;
}

@override
bool get wantKeepAlive => true;
