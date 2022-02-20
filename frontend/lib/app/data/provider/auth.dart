import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class AuthProvider {
  static getUid() {
    if (auth.currentUser != null) {
      return auth.currentUser!.uid;
    } else {
      print('로그인된 유저가 없습니다.');
    }
  }

  static getUser() {
    return auth.currentUser;
  }
}
