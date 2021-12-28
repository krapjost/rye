import 'dart:async';
import 'dart:io';
import 'package:line_icons/line_icons.dart';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:camera/camera.dart';
import 'package:rye/app/data/model/tapeModel.dart';

import 'package:rye/app/data/provider/storage.dart';
import 'package:rye/app/data/provider/firestore.dart';
import 'package:rye/app/data/provider/auth.dart';
import 'package:rye/app/data/model/feedModel.dart';

import 'package:get/get.dart';
import 'package:rye/app/ui/theme/app_colors.dart';

class WritePage extends StatefulWidget {
  @override
  _WritePageState createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  List<String> tagList = [];

  String? _description;
  String? _tapeTag;
  XFile? _video;
  String userId = AuthProvider.getUid();
  TextEditingController? textController;
  VideoPlayerController? videoController;
  StreamController<String> streamController = StreamController<String>();

  bool startedPlaying = false;
  bool _tagInputMode = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    _video = Get.arguments;
    if (_video != null) {
      videoController = VideoPlayerController.file(File(_video!.path));
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    videoController?.pause();
    videoController?.dispose();
    textController?.dispose();
    super.dispose();
  }

  Future<List<String>> fetchTagList() async {
    return await TapeProvider.getCurrentUsersTapesTagList(userId);
  }

  Future<bool> started() async {
    if (videoController != null &&
        videoController?.value.isInitialized == false) {
      await videoController?.initialize();
      await videoController?.play();
    }
    startedPlaying = true;
    return true;
  }

  Future<void> uploadFeed() async {
    streamController.add('시작');

    DateTime createdAt = DateTime.now();
    String storagePath = '$userId/${createdAt.toString()}/${_video!.name}';

    await StorageProvider.putMedia(_video!, userId, storagePath);
    String _url = await StorageProvider.fetchMediaUrl(storagePath);

    FeedModel feedModel = FeedModel(
        description: _description!,
        url: _url,
        created_at: createdAt,
        owner: _tapeTag!,
        likes: 0);

    bool isTapeCreated = await TapeProvider.isCreated(_tapeTag, userId);
    if (!isTapeCreated) {
      TapeModel tapeModel = TapeModel(
        tag: _tapeTag!,
        created_at: createdAt.toString(),
        owner: userId,
      );
      TapeProvider.addTape(tapeModel);
    }

    FeedProvider.addFeed(feedModel);

    streamController.add('완료');
    Get.toNamed('/profile');
    Get.snackbar('업로드 완료', '소중한 순간을 안전하게 저장했습니다.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Palette.BG,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.only(top: 50, left: 30, right: 30),
          children: [
            Container(
              width: double.infinity,
              height: 500,
              decoration: BoxDecoration(
                color: Color(0xFFEEEEEE),
              ),
              child: Stack(
                children: [
                  FutureBuilder(
                    future: started(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == true) {
                        return VideoPlayer(videoController!);
                      } else {
                        return SpinKitPulse(
                          color: Colors.white,
                          size: 50.0,
                        );
                      }
                    },
                  ),
                  Container(
                    color: Palette.FILTER,
                  ),
                  Align(
                    child: Text(
                      _description != null ? _description! : '어떤 순간인가요?',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Center(
                    child: StreamBuilder(
                      stream: streamController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data == "시작") {
                            return SpinKitWave(
                                color: Palette.GREY800, size: 50.0);
                          } else if (snapshot.data == "완료") {
                            return SizedBox();
                          }
                          return SizedBox();
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: Container(
                padding: EdgeInsets.only(top: 30),
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: Color(0xFFEEEEEE),
                ),
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '입력해주세요';
                        } else {
                          return null;
                        }
                      },
                      autofocus: false,
                      controller: textController,
                      onChanged: (text) {
                        if (mounted)
                          setState(
                            () {
                              _description = text;
                            },
                          );
                      },
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: '어떤 순간인가요?',
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 2,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                      ),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    FutureBuilder<List<String>>(
                      future: fetchTagList(),
                      builder: (context, snapshot) {
                        Widget widget;
                        if (snapshot.hasData) {
                          widget = Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(top: 20),
                                child: Text(
                                  '이번 기록을 추가할 필름을 선택해주세요.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                              Row(
                                children: [
                                  _tagInputMode
                                      ? Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: DropdownButton(
                                            isExpanded: true,
                                            value: _tapeTag,
                                            icon: const Icon(
                                                Icons.arrow_downward),
                                            iconSize: 24,
                                            elevation: 16,
                                            style: const TextStyle(
                                                color: Palette.GREY800),
                                            underline: Container(
                                              height: 2,
                                              color: Palette.GREY600,
                                            ),
                                            onChanged: (String? newValue) {
                                              if (mounted)
                                                setState(() {
                                                  _tapeTag = newValue!;
                                                });
                                            },
                                            items: snapshot.data!
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          ),
                                        )
                                      : Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return '입력해주세요';
                                              } else {
                                                return null;
                                              }
                                            },
                                            obscureText: false,
                                            onChanged: (text) {
                                              if (mounted)
                                                setState(
                                                  () {
                                                    _tapeTag = text;
                                                  },
                                                );
                                            },
                                            decoration: InputDecoration(
                                              hintText: '필름 이름을 지어주세요.',
                                              hintStyle: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 18,
                                                fontWeight: FontWeight.w800,
                                              ),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(4.0),
                                                  topRight:
                                                      Radius.circular(4.0),
                                                ),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(4.0),
                                                  topRight:
                                                      Radius.circular(4.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                  Expanded(
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if (mounted)
                                            _tagInputMode = !_tagInputMode;
                                        });
                                      },
                                      icon: _tagInputMode
                                          ? Icon(LineIcons.plusSquare)
                                          : Icon(LineIcons.listUl),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          widget = Text('error');
                        } else {
                          widget = Container(
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return '입력해주세요';
                                } else {
                                  return null;
                                }
                              },
                              obscureText: false,
                              onChanged: (text) {
                                if (mounted)
                                  setState(
                                    () {
                                      _tapeTag = text;
                                    },
                                  );
                              },
                              decoration: InputDecoration(
                                hintText: '필름 이름을 지어주세요.',
                                hintStyle: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(4.0),
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 2,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(4.0),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                        return widget;
                      },
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          uploadFeed();
                        },
                        child: Text('기록 더하기'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              Palette.getButtonColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
