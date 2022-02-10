import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:video_player/video_player.dart';
import 'package:rye/app/data/model/feedModel.dart';
import 'package:rye/app/data/model/tapeModel.dart';
import 'package:rye/app/data/model/userModel.dart';
import 'package:rye/app/data/provider/firestore.dart';
import 'package:rye/app/ui/theme/app_colors.dart';

class VideoWidget extends StatefulWidget {
  final FeedModel feed;
  final bool isFeedPage;

  VideoWidget(
    this.feed,
    Key? key, {
    this.isFeedPage = true,
  }) : super(key: key);
  @override
  _VideoWidgetState createState() => _VideoWidgetState();

  updateUrl(String url) {
    _VideoWidgetState().setUrl(url);
  }
}

class _VideoWidgetState extends State<VideoWidget> {
  VideoPlayerController? _controller;
  VoidCallback? listener;
  bool isPlaying = true;

  _VideoWidgetState() {
    listener = () {
      if (mounted) {
        setState(() {});
      }
    };
  }

  Future<TapeModel> fetchTape() async {
    TapeModel tape =
        await TapeProvider.getTapeModelOfCurrentFeed(widget.feed.owner);
    return tape;
  }

  Future<UserModel> fetchUser() async {
    TapeModel tape = await fetchTape();
    UserModel user = await UserProvider.getUserModel(tape.owner);

    return user;
  }

  void setUrl(String url) {
    print('!!!!!!!!!!setURL');
    if (mounted) {
      print('updateUrl');
      if (_controller != null) {
        _controller?.removeListener(listener!);
        _controller?.pause();
      }
      _controller = VideoPlayerController.network(url)
        ..initialize().then((_) {
          setState(() {});
        });
      _controller?.addListener(listener!);
    }
  }

  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.feed.video_url)
      ..initialize().then((_) {
        if (mounted) {
          _controller?.setLooping(true);
          _controller?.play();
          setState(() {});
        }
      });

    super.initState();
    _controller?.addListener(listener!);
  }

  @override
  void deactivate() {
    super.deactivate();
    print('!!!!!!!!deactivate');
    if (_controller!.value.isPlaying) _controller!.pause();
    _controller?.removeListener(listener!);
  }

  @override
  void dispose() {
    super.dispose();
    print('!!!!!!!!dispose');
    if (_controller!.value.isPlaying) _controller!.pause();
    _controller!.removeListener(listener!);
    _controller!.dispose();
  }

  void togglePlay() {
    if (mounted) {
      isPlaying
          ? (() {
              _controller?.pause();
              isPlaying = false;
            })()
          : (() {
              _controller?.play();
              isPlaying = true;
            })();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final deviceRatio;
    if (size.width > 1024) {
      deviceRatio = size.height / size.width;
    } else {
      deviceRatio = size.width / size.height;
    }

    final List<Widget> children = <Widget>[
      Container(
        width: size.width,
        child: ClipRect(
          child: AspectRatio(
            aspectRatio: deviceRatio,
            child: VideoPlayer(_controller!),
          ),
        ),
      ),
      Container(
        color: Palette.FILTER,
      ),
      widget.isFeedPage
          ? Positioned(
              bottom: 35,
              width: size.width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.feed.description,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 35,
                        ),
                      ),
                      SizedBox(
                        height: 13,
                      ),
                      Text(
                        '# ${widget.feed.owner}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        height: 21,
                      ),
                      FutureBuilder<UserModel>(
                        future: fetchUser(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            UserModel user = snapshot.data;
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  user.garden_name != null
                                      ? user.garden_name!
                                      : "이름없음",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 21,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Icon(
                                  Icons.circle,
                                  color: Colors.white,
                                  size: 5,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  '리스펙 ${user.respects.toString()}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    height: 1.3,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Text('error');
                          }
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(
                        LineIcons.thumbsUp,
                        size: 34,
                        color: Colors.white,
                      ),
                      Text(
                        widget.feed.likes.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                      SizedBox(height: 21),
                      Icon(LineIcons.commentDots,
                          size: 34, color: Colors.white),
                      Text(
                        widget.feed.comments != null
                            ? widget.feed.comments!.length.toString()
                            : '0',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ],
                  )
                ],
              ),
            )
          : Positioned(
              bottom: 80,
              child: Column(
                children: [
                  FutureBuilder<TapeModel>(
                      future: fetchTape(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          TapeModel tape = snapshot.data;

                          return Text(
                            '# ${tape.tag}',
                            style: TextStyle(color: Colors.white, fontSize: 35),
                          );
                        } else {
                          return Text(
                            'loading',
                            style: TextStyle(color: Colors.white, fontSize: 35),
                          );
                        }
                      }),
                  Text(
                    widget.feed.created_at.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
            )
    ];

    return GestureDetector(
      onTap: () {
        togglePlay();
      },
      child: Container(
        color: Palette.POINT1,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.center,
          children: children,
        ),
      ),
    );
  }
}
