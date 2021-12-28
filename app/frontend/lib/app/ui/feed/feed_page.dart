import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rye/app/data/model/feedModel.dart';
import 'package:rye/app/data/model/tapeModel.dart';
import 'package:rye/app/data/provider/firestore.dart';
import 'package:rye/app/ui/theme/app_colors.dart';
import 'package:rye/app/ui/widgets/video_widget.dart';
import 'package:rye/app/ui/widgets/bottom_navigation_widget.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  Future<List<List<FeedModel>>>? _tapeList;
  DocumentSnapshot? _lastTape;
  int? _lastIndex;

  @override
  void initState() {
    getTapes();
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  Future<List> fetchFeedList() async {
    List feedList = await FeedProvider.getRandomFeedList(3);
    return feedList;
  }

  Future<List<TapeModel>> fetchTapeList() async {
    List<TapeModel> tapeList = await TapeProvider.getRandomTapeModelList(3);
    return tapeList;
  }

  Future<List> fetchTapeListOfFeedModelList() async {
    List<TapeModel> tapeList = await fetchTapeList();

    List<List<FeedModel>> tapeListOfFeedModelList = await Future.wait(tapeList
        .map((tape) async =>
            await FeedProvider.getFeedModelListOfCurrentTape(tape.tag))
        .toList());

    return tapeListOfFeedModelList;
  }

  Future<void> getTapes() async {
    List<DocumentSnapshot> docs;
    if (_lastTape == null) {
      docs = await TapeProvider.fetchTapeDocumentList();
      print('docs length ${docs.length}, docs is null ${docs.isEmpty}');
    } else {
      docs = await TapeProvider.fetchTapeDocumentList(cursor: _lastTape);
    }
    if (docs.isEmpty == true) {
      _tapeList = null;
    } else {
      _lastTape = docs.last;
      _lastIndex = docs.length - 1;
      if (mounted) setState(() {});
      List dataList = docs.map((doc) => doc.data()).toList();
      List<TapeModel> tapeModelList =
          dataList.map((data) => TapeModel.fromJson(data)).toList();
      print('tapeModelList is $tapeModelList');
      _tapeList = Future.wait(tapeModelList
          .map((tape) async =>
              await FeedProvider.getFeedModelListOfCurrentTape(tape.tag))
          .toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: Container(
          constraints: BoxConstraints(minWidth: 300, maxWidth: 500),
          child: Stack(
            children: [
              FutureBuilder<List<List<FeedModel>>>(
                future: _tapeList,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List<List<FeedModel>>? tapes = snapshot.data;
                    print('tapes is $tapes');
                    if (tapes?.isEmpty == true) {
                      return Text('no data');
                    } else {
                      return PageView.builder(
                        itemCount: tapes?.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == _lastIndex) {
                            getTapes();
                          }
                          List feedModels = tapes![index];
                          return PageView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: feedModels.length,
                            itemBuilder: (BuildContext context, int index) {
                              return VideoWidget(
                                  feedModels[index], UniqueKey());
                            },
                          );
                        },
                      );
                    }
                  } else if (snapshot.hasError) {
                    return Text('error ${snapshot.error}');
                  } else {
                    return SpinKitFoldingCube(
                        color: Palette.POINT2, size: 50.0);
                  }
                },
              ),
              bottomNavBar(context, 2)
            ],
          ),
        ),
      ),
    );
  }
}
