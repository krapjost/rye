part of './app_pages.dart';

//TODO if access- pages that needs auth without it, go to main
abstract class Routes {
  static const ROOT = '/'; // 로그인 페이지
  static const LOGIN = '/login';
  static const SIGNUP = '/signup';
  static const FEED = '/feed';
  static const PROFILE = '/profile';
  static const TAPE = '/tape';
  static const CREATE_PROFILE = '/create-profile';
  static const ADD_PROFILE_IMAGE = '/add-profile-image';
  static const EDIT_PROFILE = '/edit-profile';
  static const CAMERA = '/camera';
  static const WEB_CAMERA = '/web-camera';
  static const WRITE = '/write';
}