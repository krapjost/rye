import 'package:flutter/material.dart';
import 'package:rye/app/ui/theme/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  UserCredential? _userCredential;
  TextEditingController? emailTextController;
  TextEditingController? passwordTextController;
  bool passwordVisibility = false;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    emailTextController = TextEditingController();
    passwordTextController = TextEditingController();
    passwordVisibility = false;
    _userCredential = null;
  }

  @override
  void dispose() {
    emailTextController?.dispose();
    passwordTextController?.dispose();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
    if (_userCredential != null) Get.offNamed('/camera');
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
                      controller: emailTextController,
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
                      controller: passwordTextController,
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
                            color: Palette.BROWN,
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
              SizedBox(height: 34),
              Container(
                color: Colors.transparent,
                padding: EdgeInsetsDirectional.fromSTEB(30, 0, 30, 0),
                width: double.infinity,
                height: 42,
                child: ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0.9),
                    shadowColor: MaterialStateProperty.resolveWith(
                        Palette.getTransparentButtonColor),
                    overlayColor: MaterialStateProperty.resolveWith(
                        Palette.getOverlayColorOfTransparentButton),
                    foregroundColor: MaterialStateProperty.all(Palette.RYE),
                    backgroundColor: MaterialStateProperty.resolveWith(
                        Palette.getButtonColor),
                  ),
                  onPressed: () {
                    emailLogin(emailTextController?.text,
                        passwordTextController?.text);
                  },
                  child: Text('로그인',
                      style: TextStyle(color: Palette.RYE, height: 0.9)),
                ),
              ),
              SizedBox(height: 21),
              Align(
                alignment: AlignmentDirectional(0, 1),
                child: Container(
                  width: double.infinity,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '계정이 없으신가요?',
                          style: TextStyle(
                            fontFamily: 'Noto Sans',
                            color: Palette.RYE.withOpacity(0.5),
                            fontSize: 11,
                            height: 1,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            print('pressed');
                            Get.toNamed('/signup');
                          },
                          child: Text(
                            '회원가입',
                            style: TextStyle(
                              fontFamily: 'Noto Sans',
                              color: Palette.RYE,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              height: 1.1,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> emailLogin(emailString, passwordString) async {
    print('email is $emailString');
    if (emailString != '' && passwordString != '') {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailString.trim(),
          password: passwordString.trim(),
        );
        setState(() {
          _userCredential = userCredential;
        });
      } on FirebaseAuthException catch (e) {
        print('error code is ${e.code}');
        if (e.code == 'user-not-found') {
          Get.snackbar('로그인 에러', '가입된 사용자가 없습니다.');
        } else if (e.code == 'wrong-password') {
          Get.snackbar('로그인 에러', '비밀번호를 잘못 입력하셨습니다.');
        } else if (e.code == 'invalid-email') {
          Get.snackbar('로그인 에러', '잘못된 이메일 형식입니다.');
        }
      }
    } else {
      Get.snackbar('로그인 에러', '이메일과 비밀번호를 입력해주세요.');
    }
  }
}
