import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:rye/app/data/provider/auth.dart';
import 'package:rye/app/data/provider/firestore.dart';
import 'package:rye/app/ui/theme/app_colors.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController? userNameController;
  TextEditingController? gardenNameController;
  TextEditingController? descriptionController;

  @override
  void initState() {
    if (mounted) super.initState();
    userNameController = TextEditingController();
    gardenNameController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    userNameController?.dispose();
    gardenNameController?.dispose();
    descriptionController?.dispose();
    super.dispose();
  }

  Future<void> updateProfile(
      {String userName = '',
      String gardenName = '',
      String description = ''}) async {

    if (userName.isEmpty) {
      Get.snackbar('사용자 이름', '사용자 이름을 입력해주세요.');
      return;
    };
    if (gardenName.isEmpty) {
      Get.snackbar('정원 이름', '정원 이름을 입력해주세요.');
      return;
    };
    if (description.isEmpty) {
      Get.snackbar('정원 설명', '정원 설명을 입력해주세요.');
      return;
    };

    String uid = AuthProvider.getUid();
    await UserProvider.updateUser(uid, 'name', userName);
    await UserProvider.updateUser(uid, 'garden_name', gardenName);
    await UserProvider.updateUser(uid, 'description', description);

    Get.snackbar('프로필 수정', '프로필 수정에 성공했습니다.');
    Get.toNamed('/profile');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Palette.BG,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(21, 8, 21, 8),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0x22EEEEEE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  cursorColor: Palette.GREY600,
                  cursorWidth: 8,
                  cursorHeight: 21,
                  controller: userNameController,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: '사용자 이름',
                    labelStyle: TextStyle(
                      fontFamily: 'Noto Sans',
                      color: Palette.GREY600,
                      fontSize: 13,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Palette.GREY400,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Palette.BG,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  style: TextStyle(
                    fontFamily: 'Noto Sans',
                    color: Palette.GREY800,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(21, 8, 21, 8),
              child: Container(
                width: double.infinity,
                child: TextFormField(
                  cursorColor: Palette.GREY600,
                  cursorWidth: 8,
                  cursorHeight: 21,
                  controller: gardenNameController,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: '정원 이름',
                    labelStyle: TextStyle(
                      fontFamily: 'Noto Sans',
                      color: Palette.GREY600,
                      fontSize: 13,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Palette.GREY400,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Palette.BG,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    fontFamily: 'Noto Sans',
                    color: Palette.GREY600,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(21, 8, 21, 8),
              child: Container(
                width: double.infinity,
                child: TextFormField(
                  cursorColor: Palette.GREY600,
                  cursorWidth: 8,
                  cursorHeight: 21,
                  maxLines: 2,
                  controller: descriptionController,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: '정원 설명',
                    labelStyle: TextStyle(
                      fontFamily: 'Noto Sans',
                      color: Palette.GREY600,
                      fontSize: 13,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Palette.GREY400,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Palette.BG,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    fontFamily: 'Noto Sans',
                    color: Palette.GREY600,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            SizedBox(
              height: 21,
            ),
            Container(
              padding: EdgeInsetsDirectional.fromSTEB(21, 0, 21, 0),
              width: double.infinity,
              height: 42,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.resolveWith(Palette.getButtonColor),
                ),
                onPressed: () {
                  updateProfile(
                      gardenName: gardenNameController!.text,
                      userName: userNameController!.text,
                      description: descriptionController!.text);
                },
                child: Text('수정'),
              ),
            ),
            SizedBox(
              height: 21,
            ),
            Container(
              padding: EdgeInsetsDirectional.fromSTEB(21, 0, 21, 0),
              height: 42,
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.resolveWith(Palette.getButtonColor),
                ),
                onPressed: () {
                  FirebaseAuth.instance
                      .signOut()
                      .then((_) => Get.toNamed('/login'));
                },
                child: Text('로그아웃'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
