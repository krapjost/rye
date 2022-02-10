import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:rye/app/data/provider/firestore.dart';
import 'package:rye/app/ui/theme/app_colors.dart';

class CreateProfilePage extends StatefulWidget {
  @override
  _CreateProfilePageState createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  TextEditingController? textController1;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    textController1 = TextEditingController();
  }

  @override
  void dispose() {
    textController1?.dispose();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> updateGardenName(String gardenName) async {
    if (gardenName.isEmpty) {
      Get.snackbar('빈 이름', '정원 이름을 지어주세요');
      return;
    }
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        UserProvider.updateUser(user.uid, 'garden_name', gardenName.trim());
        Get.toNamed('/add-profile-image');
      } else {
        print('updateGardenName got error ::: 유저가 없을수가');
      }
    } catch (e) {
      print('updateGardenName got error ::::: $e');
    }
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
              padding: EdgeInsetsDirectional.fromSTEB(15, 12, 15, 0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0x22EEEEEE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(15, 5, 15, 0),
                  child: TextFormField(
                    autofocus: true,
                    cursorColor: Palette.POINT2,
                    cursorHeight: 21,
                    controller: textController1,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: '정원 이름을 지어주세요.',
                      labelStyle: TextStyle(
                        fontFamily: 'Noto Sans',
                        color: Palette.GREY800,
                        fontSize: 13,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Palette.GREY400,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Palette.GREY800,
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
            ),
            Align(
              alignment: AlignmentDirectional(1, 0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 12, 35, 0),
                child: Text(
                  '나중에 수정할 수 있습니다.',
                  style: TextStyle(
                    fontFamily: 'Noto Sans',
                    color: Palette.GREY600,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
                  backgroundColor:
                      MaterialStateProperty.resolveWith(Palette.getButtonColor),
                ),
                onPressed: () {
                  updateGardenName(textController1!.text);
                },
                child: Text('이 이름이 좋아요'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
