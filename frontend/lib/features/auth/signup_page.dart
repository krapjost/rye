import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController? textController1;
  TextEditingController? textController2;
  StreamController<String> streamController = StreamController<String>();
  bool passwordVisibility = false;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    textController1 = TextEditingController();
    textController2 = TextEditingController();
    passwordVisibility = false;
  }

  @override
  void dispose() {
    textController1?.dispose();
    textController2?.dispose();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: Container(
          constraints: BoxConstraints(minWidth: 300, maxWidth: 500),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(15, 12, 15, 0),
                child: Container(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(15, 5, 15, 0),
                    child: TextFormField(
                      cursorColor: Palette.RYE,
                      cursorWidth: 3,
                      cursorHeight: 18,
                      controller: textController1,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: '이메일 주소',
                        labelStyle: TextStyle(
                          fontFamily: 'Noto Sans',
                          color: Palette.RYE,
                          fontSize: 13,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Palette.BROWN,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      style: TextStyle(
                        fontFamily: 'Noto Sans',
                        color: Colors.white,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(15, 20, 15, 0),
                child: Container(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                    child: TextFormField(
                      cursorColor: Palette.RYE,
                      cursorWidth: 3,
                      cursorHeight: 18,
                      controller: textController2,
                      obscureText: !passwordVisibility,
                      decoration: InputDecoration(
                        labelText: '비밀번호',
                        labelStyle: TextStyle(
                          fontFamily: 'Noto Sans',
                          color: Palette.RYE,
                          fontSize: 13,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Palette.BROWN,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        suffixIcon: InkWell(
                          onTap: () => setState(
                            () => passwordVisibility = !passwordVisibility,
                          ),
                          child: Icon(
                            passwordVisibility
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 22,
                            color: Palette.GREY600,
                          ),
                        ),
                      ),
                      style: TextStyle(
                        fontFamily: 'Noto Sans',
                        color: Colors.white,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.start,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return '비밀번호 입력해주세요.';
                        }
                        if (val.length < 6) {
                          return '비밀번호는 6자 이상입니다.';
                        }
                        return null;
                      },
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
                child: StreamBuilder(
                  stream: streamController.stream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      var progress = snapshot.data;
                      if (progress == '시작') {
                        return SpinKitWave(color: Palette.POINT2, size: 40.0);
                      } else if (progress == '완료') {
                        return SizedBox();
                      } else {
                        return SizedBox();
                      }
                    } else {
                      return ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0.9),
                          shadowColor: MaterialStateProperty.resolveWith(
                              Palette.getTransparentButtonColor),
                          overlayColor: MaterialStateProperty.resolveWith(
                              Palette.getOverlayColorOfTransparentButton),
                          foregroundColor:
                              MaterialStateProperty.all(Palette.RYE),
                          backgroundColor: MaterialStateProperty.resolveWith(
                              Palette.getButtonColor),
                        ),
                        onPressed: () {
                          emailSignup(
                              textController1?.text, textController2?.text);
                        },
                        child: Text(
                          '회원가입',
                          style: TextStyle(color: Palette.RYE, height: 0.9),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> emailSignup(String? email, String? password) async {
    if (email != '' && password != '') {
      try {
        streamController.add('시작');
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email!,
          password: password!,
        );

        String uid = userCredential.user!.uid;
        //!TODO 이미지 넣을 것
        String _image_url = '';

        UserModel userModel = UserModel(
          name: '',
          email: email,
          description: '',
          image_url: _image_url,
          respects: 0,
        );
        await UserProvider.addUser(userModel, uid);

        streamController.add('완료');
        /* Get.offAllNamed('/camera'); */
      } on FirebaseAuthException catch (e) {
        print('auth error ${e.code}');
        if (e.code == 'weak-password') {
          /* Get.snackbar('회원가입 에러', '너무 쉬운 비밀번호입니다.'); */
        } else if (e.code == 'email-already-in-use') {
          /* Get.snackbar('회원가입 에러', '이미 사용 중인 이메일입니다.'); */
        } else if (e.code == 'invalid-email') {
          /* Get.snackbar('회원가입 에러', '잘못된 이메일 형식입니다.'); */
        }
      }
    } else {
      /* Get.snackbar('회원가입 에러', '이메일과 비밀번호를 입력해주세요.'); */
    }
  }
}
