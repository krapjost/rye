import 'dart:ui';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rye/app/data/model/userModel.dart';
import 'package:rye/app/data/provider/firestore.dart';
import 'package:rye/app/data/model/tapeModel.dart';
import 'package:rye/app/data/model/feedModel.dart';

import 'package:get/get.dart';
import 'package:rye/app/ui/theme/app_colors.dart';
import 'package:rye/app/ui/widgets/bottom_navigation_widget.dart';

import 'package:video_player/video_player.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? firebaseUser = FirebaseAuth.instance.currentUser;
  Future<UserModel>? _userModel;
  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    if (firebaseUser != null) {
      _userModel = UserProvider.getUserModel(firebaseUser!.uid);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void deactivate() {
    print('deactivate ');
    super.deactivate();
  }

  Future<Widget> initVideos(String url) async {
    print('try to init videos');
    VideoPlayerController controller = VideoPlayerController.network(url);
    await controller.initialize();
    return VideoPlayer(controller);
  }

  Future<ProfileModel> fetchProfileInfo() async {
    List<TapeModel> tapeList =
        await TapeProvider.getTapeModelListOfCurrentUser(firebaseUser?.uid);

    List<List<FeedModel>> listOfFeedList = await Future.wait(tapeList.map(
        (tape) async =>
            await FeedProvider.getFeedModelListOfCurrentTape(tape.tag)));
    List<FeedModel> flattendFeedList =
        listOfFeedList.expand((feed) => feed).toList();

    UserModel _user = await _userModel!;

    return ProfileModel(_user.name, _user.garden_name, _user.email,
        _user.description, _user.image_url, _user.respects,
        total_tapes: tapeList.length, total_feeds: flattendFeedList.length);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: Container(
          constraints: BoxConstraints(minWidth: 300, maxWidth: 500),
          child: Stack(
            children: [
              Container(
                color: Colors.black,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        height: size.height * 0.7,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            FutureBuilder<UserModel>(
                              future: _userModel,
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  String url = snapshot.data.image_url;
                                  print("profile page usermodel url is $url");
                                  if (url == "") {
                                    url = "https://i.imgur.com/iu7Tqfg.jpeg";
                                  }

                                  return Positioned(
                                    top: 0,
                                    child: Container(
                                      height: size.height * 0.6,
                                      width: size.width,
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: url,
                                        height: 100.0,
                                        width: 100.0,
                                        placeholder: (context, url) =>
                                            SpinKitCircle(color: Palette.BG),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                  );
                                } else {
                                  return SpinKitRing(color: Palette.BG);
                                }
                              },
                            ),
                            Positioned(
                              bottom: 20,
                              child: ClipRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 10.0, sigmaY: 10.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Palette.GREY800.withOpacity(0.7),
                                    ),
                                    padding: EdgeInsets.all(20),
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: FutureBuilder<ProfileModel>(
                                      future: fetchProfileInfo(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (snapshot.hasData) {
                                          ProfileModel profile = snapshot.data;
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 5, bottom: 15),
                                                child: Text(
                                                    profile.garden_name != null
                                                        ? profile.garden_name!
                                                        : '정원 이름이 없습니다',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                              Container(
                                                margin: EdgeInsets.all(5),
                                                child: Text(
                                                  profile.description != ''
                                                      ? profile.description
                                                      : '프로필 수정 페이지에서\n정원 설명을 적어주세요.',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 10, bottom: 5),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '기록장 ${profile.total_tapes}',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Text(
                                                      '기록 ${profile.total_feeds}',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Text(
                                                      '리스펙 ${profile.respects}',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        } else {
                                          return Text("loading");
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        height: 42,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                                Palette.getButtonColor),
                          ),
                          onPressed: () {
                            Get.toNamed('/edit-profile');
                            print('pressed');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(LineIcons.cog),
                              SizedBox(width: 10),
                              Text('프로필 수정'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 21,
                      ),
                    ),
                    FutureBuilder<List<TapeModel>>(
                      future: TapeProvider.getTapeModelListOfCurrentUser(
                          firebaseUser!.uid),
                      builder: (context, snapshot) {
                        Widget tapeWidget;
                        if (snapshot.hasData) {
                          List<TapeModel> tapes = snapshot.data!;
                          int tapesCount = tapes.toSet().toList().length;

                          tapeWidget = SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                TapeModel tape = tapes[index];
                                DateTime startDate =
                                    DateTime.parse(tape.created_at);
                                Duration diff =
                                    DateTime.now().difference(startDate);

                                return FutureBuilder<List<FeedModel>>(
                                  future: FeedProvider
                                      .getFeedModelListOfCurrentTape(tape.tag),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      List<FeedModel> feeds = snapshot.data!;

                                      return Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 20),
                                            height: 160,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: feeds.length,
                                              itemBuilder: (context, index) {
                                                FeedModel feed = feeds[index];
                                                return Container(
                                                  height: 160,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                    color: Palette.GREY400,
                                                    border: Border.all(
                                                        color: Colors.white70,
                                                        width: .5),
                                                  ),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        feed.thumbnail_url,
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit: BoxFit.cover,
                                                            colorFilter:
                                                                ColorFilter.mode(
                                                                    Colors.red,
                                                                    BlendMode
                                                                        .colorBurn)),
                                                      ),
                                                    ),
                                                    placeholder:
                                                        (context, url) =>
                                                            SpinKitRipple(
                                                                color: Palette
                                                                    .GREY800),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 40, top: 20),
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children: [
                                                LineIcon.film(),
                                                TextButton(
                                                  onPressed: () {
                                                    Get.toNamed('/tape',
                                                        arguments: [
                                                          tape,
                                                          feeds
                                                        ]);
                                                  },
                                                  child: Text(
                                                    ' ${tape.tag}',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 40, top: 10, bottom: 50),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                LineIcon.hourglass(size: 18),
                                                Text(
                                                  '같이 산지 ${diff.inDays}일 째',
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                                Center(
                                                  widthFactor: 5,
                                                  child: Icon(
                                                    Icons.circle,
                                                    size: 4,
                                                  ),
                                                ),
                                                LineIcon.images(size: 18),
                                                Text(
                                                  '기록 0(나중에)건',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text('에러');
                                    }
                                    return Text('로딩');
                                  },
                                );
                              },
                              childCount: tapesCount,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          tapeWidget = SliverToBoxAdapter(child: Text('error'));
                        } else {
                          tapeWidget = SliverToBoxAdapter(
                            child: SpinKitThreeBounce(
                              color: Palette.GREY800,
                              size: 40.0,
                            ),
                          );
                        }
                        return tapeWidget;
                      },
                    ),
                  ],
                ),
              ),
              bottomNavBar(context, 1),
            ],
          ),
        ),
      ),
    );
  }
}