import 'dart:ui';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rye/app/ui/widgets/video_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:rye/app/data/model/userModel.dart';
import 'package:rye/app/data/provider/firestore.dart';
import 'package:rye/app/data/model/tapeModel.dart';
import 'package:rye/app/data/model/feedModel.dart';
import 'package:rye/app/ui/theme/app_colors.dart';
import 'package:rye/app/ui/widgets/thumbnail_widget.dart';

import 'package:get/get.dart';

class TapePage extends StatefulWidget {
  @override
  _TapePageState createState() => _TapePageState();
}

class _TapePageState extends State<TapePage> {
  User? firebaseUser = FirebaseAuth.instance.currentUser;
  Future<UserModel>? user;
  FirebaseStorage storage = FirebaseStorage.instance;

  ImageFormat _format = ImageFormat.JPEG;
  int _quality = 50;
  int _sizeH = 0;
  int _sizeW = 0;
  int _timeMs = 0;
  var _tapeWithFeeds = Get.arguments;
  String? _tempDir;

  @override
  void initState() {
    super.initState();
    if (firebaseUser != null) {
      user = UserProvider.getUserModel(firebaseUser!.uid);
    }
    getTemporaryDirectory().then((d) => _tempDir = d.path);
    print('targuments are $_tapeWithFeeds');
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<GenThumbnailImage> getThumbnailImageWidget(String url) async {
    GenThumbnailImage _futreImage = GenThumbnailImage(
        thumbnailRequest: ThumbnailRequest(
            video: url,
            thumbnailPath: _tempDir,
            imageFormat: _format,
            maxHeight: _sizeH,
            maxWidth: _sizeW,
            timeMs: _timeMs,
            quality: _quality));
    return _futreImage;
  }

  @override
  Widget build(BuildContext context) {
    TapeModel tape = _tapeWithFeeds[0];
    List<FeedModel> feeds = _tapeWithFeeds[1];
    FeedModel firstFeed = feeds[0];
    print('feeds ???????? $feeds');
    print('feeds lengthj ????? ${feeds.length}');
    print('first feed ????????? $firstFeed');
    print('tape ?????????????? $tape');

    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: ListView(
          children: [
            Container(
              color: Palette.GREY800,
              width: size.width,
              height: size.height * 0.7,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    child:
                        VideoWidget(firstFeed, UniqueKey(), isFeedPage: false),
                  ),
                  Positioned(
                    bottom: 20,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          color: Colors.white.withOpacity(0.3),
                          width: size.width * 0.8,
                          height: 42,
                          child: TextButton(
                            onPressed: () {
                              print('play');
                            },
                            child: Text(
                              'PLAY',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Sans',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  '기록 ${feeds.length}건',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics:
                  NeverScrollableScrollPhysics(), // to disable GridView's scrolling
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, //1 개의 행에 보여줄 item 개수
                childAspectRatio: 1 / 1.5, //item 의 가로 1, 세로 2 의 비율
                mainAxisSpacing: 5, //수평 Padding
                crossAxisSpacing: 5, //수직 Padding
              ),
              itemCount: feeds.length,
              itemBuilder: (BuildContext context, int index) {
                FeedModel feed = feeds[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Palette.GREY400,
                  ),
                  child: FutureBuilder<GenThumbnailImage>(
                    future: getThumbnailImageWidget(feed.url),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data!;
                      } else if (snapshot.hasError) {
                        return Icon(Icons.error);
                      }
                      return SpinKitRipple(
                        color: Palette.GREY800,
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
