import 'package:get/get.dart';
import 'package:rye/app/ui/router/root_router.dart';
import 'package:rye/app/ui/auth/login_page.dart';
import 'package:rye/app/ui/auth/signup_page.dart';
import 'package:rye/app/ui/profile/profile_page.dart';
import 'package:rye/app/ui/feed/feed_page.dart';
import 'package:rye/app/ui/onboarding/create_profile_page.dart';
import 'package:rye/app/ui/onboarding/add_profile_image_page.dart';

import 'package:rye/app/ui/editProfile/edit_profile_page.dart';
import 'package:rye/app/ui/camera/camera_page.dart';
import 'package:rye/app/ui/camera/web_camera_page.dart';

part './app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: Routes.ROOT, page: () => RootRouter()),
    GetPage(name: Routes.LOGIN, page: () => LoginPage()),
    GetPage(name: Routes.SIGNUP, page: () => SignupPage()),
    GetPage(name: Routes.FEED, page: () => FeedPage()),
    GetPage(name: Routes.PROFILE, page: () => ProfilePage()),
    GetPage(name: Routes.CREATE_PROFILE, page: () => CreateProfilePage()),
    GetPage(name: Routes.ADD_PROFILE_IMAGE, page: () => AddProfileImagePage()),
    GetPage(name: Routes.EDIT_PROFILE, page: () => EditProfilePage()),
    GetPage(name: Routes.CAMERA, page: () => CameraPage()),
    GetPage(name: Routes.WEB_CAMERA, page: () => WebCameraPage()),
  ];
}
