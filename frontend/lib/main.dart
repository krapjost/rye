import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rye/app/ui/theme/app_colors.dart';

import 'app/routes/app_pages.dart';
import 'app/ui/router/auth_checker.dart';
import 'app/ui/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    GetMaterialApp(
      initialRoute: Routes.ROOT,
      theme: appThemeData,
      getPages: AppPages.pages,
      home: App(),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('firebase load fail ${snapshot.error}'),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return AuthChecker();
        } else {
          return Center(
            child: SpinKitDualRing(
              color: Palette.GREY800,
            ),
          );
        }
      },
    );
  }
}
