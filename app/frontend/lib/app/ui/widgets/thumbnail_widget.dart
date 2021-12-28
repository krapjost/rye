import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:rye/app/ui/theme/app_colors.dart';

class ThumbnailRequest {
  final String? video;
  final String? thumbnailPath;
  final ImageFormat? imageFormat;
  final int? maxHeight;
  final int? maxWidth;
  final int? timeMs;
  final int? quality;

  const ThumbnailRequest(
      {this.video,
      this.thumbnailPath,
      this.imageFormat,
      this.maxHeight,
      this.maxWidth,
      this.timeMs,
      this.quality});
}

class ThumbnailResult {
  final Image? image;
  final int? dataSize;
  final int? height;
  final int? width;
  const ThumbnailResult({this.image, this.dataSize, this.height, this.width});
}

Future<ThumbnailResult> genThumbnail(ThumbnailRequest r) async {
  //WidgetsFlutterBinding.ensureInitialized();
  Uint8List? bytes;
  final Completer<ThumbnailResult> completer = Completer();
  if (r.thumbnailPath != null) {
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
        video: r.video!,
        thumbnailPath: r.thumbnailPath,
        imageFormat: r.imageFormat!,
        maxHeight: r.maxHeight!,
        maxWidth: r.maxWidth!,
        timeMs: r.timeMs!,
        quality: r.quality!);

    print("thumbnail file is located: $thumbnailPath");

    final file = File(thumbnailPath!);
    bytes = file.readAsBytesSync();
  } else {
    bytes = await VideoThumbnail.thumbnailData(
        video: r.video!,
        imageFormat: r.imageFormat!,
        maxHeight: r.maxHeight!,
        maxWidth: r.maxWidth!,
        timeMs: r.timeMs!,
        quality: r.quality!);
  }

  int _imageDataSize = bytes!.length;
  print("image size: $_imageDataSize");

  final _image = Image.memory(
    bytes,
    fit: BoxFit.cover,
  );
  _image.image
      .resolve(ImageConfiguration())
      .addListener(ImageStreamListener((ImageInfo info, bool _) {
    completer.complete(ThumbnailResult(
      image: _image,
      dataSize: _imageDataSize,
      height: info.image.height,
      width: info.image.width,
    ));
  }));
  return completer.future;
}

class GenThumbnailImage extends StatefulWidget {
  final ThumbnailRequest? thumbnailRequest;

  const GenThumbnailImage({Key? key, this.thumbnailRequest}) : super(key: key);

  @override
  _GenThumbnailImageState createState() => _GenThumbnailImageState();
}

class _GenThumbnailImageState extends State<GenThumbnailImage> {
  Widget? _image;

  @override
  Widget build(BuildContext context) {
    print('image is $_image');
    if (_image == null) {
      return FutureBuilder<ThumbnailResult>(
        future: genThumbnail(widget.thumbnailRequest!),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            _image = snapshot.data.image;
            return Container(
              color: Palette.POINT1,
              child: Expanded(child: _image!),
            );
          } else if (snapshot.hasError) {
            return Container(
              padding: EdgeInsets.all(8.0),
              color: Colors.red,
              child: Text(
                "Error:\n${snapshot.error.toString()}",
              ),
            );
          } else {
            return Container(
              alignment: Alignment.center,
              child: SpinKitPulse(
                color: Palette.BG,
              ),
            );
          }
        },
      );
    } else {
      return Container(
        child: _image,
      );
    }
  }
}
