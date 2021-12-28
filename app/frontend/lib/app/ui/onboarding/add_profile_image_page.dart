import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:rye/app/data/provider/auth.dart';
import 'package:rye/app/data/provider/firestore.dart';
import 'package:rye/app/data/provider/storage.dart';
import 'package:rye/app/ui/theme/app_colors.dart';

class AddProfileImagePage extends StatefulWidget {
  @override
  _AddProfileImagePageState createState() => _AddProfileImagePageState();
}

class _AddProfileImagePageState extends State<AddProfileImagePage> {
  final ImagePicker _picker = ImagePicker();

  String? uid = AuthProvider.getUid();

  void _onImageButtonPressed(ImageSource source,
      {BuildContext? context}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
      );

      if (pickedFile != null) {
        if (uid != null) {
          String storagePath = '$uid/profile_image';
          await StorageProvider.putMedia(pickedFile, uid!, storagePath);
          String url = await StorageProvider.fetchMediaUrl(storagePath);
          await UserProvider.updateUser(uid!, 'image_url', url);
          Get.toNamed('/profile');
          Get.snackbar('가입완료', '행복한 정원 생활 되세요!');
        } else {
          Get.toNamed('/login');
          Get.snackbar('로그인', '로그인을 해주세요.');
        }
      } else {
        Get.snackbar('프로필', '정원 사진을 올려주세요.');
      }
    } catch (e) {
      print('add image error');
    }
  }

  void skip() {
    Get.toNamed('/profile');
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
          width: size.width,
          alignment: Alignment.center,
          color: Palette.BG,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '프로필 배경 사진을 업로드 해주세요',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 34),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      LineIcons.photoVideo,
                      size: 34,
                    ),
                    onPressed: () {
                      _onImageButtonPressed(ImageSource.gallery,
                          context: context);
                    },
                  ),
                  SizedBox(
                    width: 21,
                  ),
                  IconButton(
                    icon: Icon(
                      LineIcons.camera,
                      size: 34,
                    ),
                    onPressed: () {
                      _onImageButtonPressed(ImageSource.camera,
                          context: context);
                    },
                  ),
                ],
              ),
              SizedBox(height: 34),
              Container(
                color: Colors.transparent,
                width: double.infinity,
                padding: EdgeInsetsDirectional.fromSTEB(30, 0, 30, 0),
                height: 42,
                child: ElevatedButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.resolveWith(
                          Palette.getOverlayColorOfButton),
                      foregroundColor: MaterialStateProperty.all(Palette.BG),
                      backgroundColor: MaterialStateProperty.resolveWith(
                          Palette.getButtonColor),
                    ),
                    onPressed: () {
                      skip();
                    },
                    child: Text('나중에 할래요')),
              )
            ],
          )),
    );
  }
}
