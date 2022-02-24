import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rye/app/ui/auth/login_page.dart';
import './root_router.dart';

class AuthChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasData) {
          return RootRouter();
        } else if (snapshot.hasError) {
          print("auth has error : ${snapshot.error}");
          return LoginPage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
