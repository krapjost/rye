import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPreview extends StatefulWidget {
  final String? videoPath;
  VideoPreview({String? videoPath}) : this.videoPath = '';

  @override
  _VideoPreviewState createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    print('!!!!!!!!!!!!!!!video path on initState ${widget.videoPath}');
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    if (widget.videoPath != '') {
      _controller = VideoPlayerController.asset(widget.videoPath!)
        ..initialize().then(
          (_) {
            print('is contoller init? :::: filepath : ${widget.videoPath}');
            setState(() {});
          },
        );
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
    print('${widget.videoPath}');
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller != null && _controller!.value.isInitialized) {
      return Container(
        child: Center(
          child: VideoPlayer(_controller!),
        ),
      );
    } else {
      return Container();
    }
  }
}
