import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rye/app/data/model/feedModel.dart';
import 'package:rye/app/data/model/tapeModel.dart';
import 'package:rye/app/data/model/userModel.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference users = FirebaseFirestore.instance.collection('users');
CollectionReference feeds = FirebaseFirestore.instance.collection('feeds');
CollectionReference tapes = FirebaseFirestore.instance.collection('tapes');

class UserProvider {
  static addUser(userModel, String uid) {
    users
        .doc(uid)
        .set(userModel.toJson())
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  static updateUser(String uid, String field, String item) {
    users
        .doc(uid)
        .update({field: item})
        .then((value) => print('updated'))
        .catchError((e) => print('error'));
  }

  static Future<UserModel> getUserModel(String uid) async {
    UserModel user = UserModel(
        name: '', email: '', description: '', image_url: '', respects: 0);
    try {
      DocumentSnapshot snapshot = await users.doc(uid).get();
      user = UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
      return user;
    } catch (e) {
      print('lib/app/data/provider/firestore.dart :\n error occured on getUserModel :\n $e');
      return user;
    }
  }
}

class FeedProvider {
  static addFeed(feedModel) {
    feeds
        .add(feedModel.toJson())
        .then((value) => print('Feed Added'))
        .catchError((error) => print('Failed on add Feed: $error'));
  }

  static Future<List<FeedModel>> getFeedModelListOfCurrentTape(tag) async {
    List<FeedModel> feedList = [];
    try {
      var snapshot = await feeds.where('owner', isEqualTo: tag).get();
      print("! snapshot: $snapshot, tag: $tag, docs : ${snapshot.docs[0].data()}");
      feedList = snapshot.docs
          .map((doc) => FeedModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      print('getFeedModelListOf Current tape ::::: $feedList');
    } catch (e) {
      print('ERROR : lib/app/data/provider/firestore.dart :\n FeedProvider.getFeedModelListOfCurrentTape:\n $e');
    }
    return feedList;
  }

  static Future<List> getRandomFeedList(limit) async {
    List feedList = [];
    try {
      var snapshot = await feeds.limit(limit).get();
      List dataList = snapshot.docs.map((doc) => doc.data()).toList();
      feedList = dataList.map((feed) => FeedModel.fromJson(feed)).toList();
      print('feed list is $feedList');
    } catch (e) {
      print('error occured on fetching random feeds $e');
    }
    return feedList;
  }
}

class TapeProvider {
  static addTape(tapeModel) {
    tapes
        .add(tapeModel.toJson())
        .then((value) => print('tape Added'))
        .catchError((error) => print('error on add Tape: $error'));
  }

  static Future<List<String>> getCurrentUsersTapesTagList(uid) async {
    List<String> tagList = [];
    try {
      var snapshot = await tapes.where('owner', isEqualTo: uid).get();
      List dataList = snapshot.docs.map((doc) => doc.data()).toList();
      tagList = dataList.map((data) => data['tag'].toString()).toSet().toList();
    } catch (e) {
      print('error occured on fetching currentUsersTapes $e');
    }
    return tagList;
  }

  static Future<List<TapeModel>> getTapeModelListOfCurrentUser(uid) async {
    List<TapeModel> tapeList = [];
    try {
      QuerySnapshot snapshot = await tapes.where('owner', isEqualTo: uid).get();
      tapeList = snapshot.docs
          .map((doc) => TapeModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('error occured on fetching currentUsersTapes $e');
    }
    return tapeList;
  }

  static Future<TapeModel> getTapeModelOfCurrentFeed(tag) async {
    TapeModel tape = TapeModel(tag: '', created_at: '', owner: '');
    try {
      QuerySnapshot snapshot =
          await tapes.where('tag', isEqualTo: tag).limit(1).get();

      tape = TapeModel.fromJson(
          snapshot.docs.first.data() as Map<String, dynamic>);
      return tape;
    } catch (e) {
      print('error on getCurrentFeedsTapeModel $e');
      return tape;
    }
  }

  static Future<bool> isCreated(tag, user) async {
    var snapshot = await tapes
        .where('owner', isEqualTo: user)
        .where('tag', isEqualTo: tag)
        .get();
    if (snapshot.size > 0) return true;
    return false;
  }

  static Future<List<TapeModel>> getRandomTapeModelList(limit) async {
    List<TapeModel> tapeList = [];
    try {
      QuerySnapshot snapshot = await tapes.limit(limit).get();
      List dataList = snapshot.docs.map((doc) => doc.data()).toList();
      tapeList = dataList.map((data) => TapeModel.fromJson(data)).toList();
      return tapeList;
    } catch (e) {
      print('error occured on getRandomTapeList ::: $e');
      return tapeList;
    }
  }

  static Future<List<DocumentSnapshot>> fetchTapeDocumentList(
      {int limit = 10, DocumentSnapshot? cursor = null}) async {
    List<DocumentSnapshot> docList = [];
    try {
      if (cursor == null) {
        QuerySnapshot snapshot =
            await tapes.orderBy('created_at').limit(limit).get();
        docList = snapshot.docs.toList();
        print("fetchTapeDocumentList $docList");
      } else {
        QuerySnapshot snapshot = await tapes
            .orderBy('created_at')
            .startAfterDocument(cursor)
            .limit(limit)
            .get();
        docList = snapshot.docs.toList();
      }
    } catch (e) {
      print('ERROR : data/provider/firestore.dart :\nTapeProvider.fetchTapeDocumentList\n:$e');
    }
    return docList;
  }
}
