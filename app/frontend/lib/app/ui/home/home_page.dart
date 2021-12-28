import 'package:flutter/material.dart';
import 'package:rye/app/ui/auth/login_page.dart';
import 'package:rye/app/ui/camera/camera_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasData) {
          print('HOME PAGE ::: AUTH STATE CHANGED ::: ${snapshot.data}');
          return CameraPage();
        } else if (snapshot.hasError) {
          return Text('firebase auth has error ::: ${snapshot.error}');
        } else {
          return LoginPage();
        }
      },
    );
  }
}
