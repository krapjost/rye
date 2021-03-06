import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rye/constants/theme/colors.dart';
import 'package:rye/constants/theme/buttonStyles.dart';

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
    if (_userCredential != null) print("logged in");
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
                      cursorColor: DarkThemeColor.PRIMARY,
                      cursorWidth: 3,
                      cursorHeight: 18,
                      controller: emailTextController,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: '????????? ??????',
                        labelStyle: TextStyle(
                          fontFamily: 'Noto Sans',
                          color: DarkThemeColor.PRIMARY,
                          fontSize: 13,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: DarkThemeColor.SECONDARY,
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
                      cursorColor: DarkThemeColor.PRIMARY,
                      cursorWidth: 3,
                      cursorHeight: 18,
                      controller: passwordTextController,
                      obscureText: !passwordVisibility,
                      decoration: InputDecoration(
                        labelText: '????????????',
                        labelStyle: TextStyle(
                          fontFamily: 'Noto Sans',
                          color: DarkThemeColor.PRIMARY,
                          fontSize: 13,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: DarkThemeColor.SECONDARY,
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
                            color: DarkThemeColor.SECONDARY,
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
                  style: RyeButton.outlineButtonStyle,
                  onPressed: () {
                    emailLogin(emailTextController?.text,
                        passwordTextController?.text);
                  },
                  child: Text('?????????',
                      style: TextStyle(
                          color: DarkThemeColor.PRIMARY, height: 0.9)),
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
                          '????????? ????????????????',
                          style: TextStyle(
                            fontFamily: 'Noto Sans',
                            color: DarkThemeColor.PRIMARY.withOpacity(0.5),
                            fontSize: 11,
                            height: 1,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            print('to signup page');
                            /* Get.toNamed('/signup'); */
                          },
                          child: Text(
                            '????????????',
                            style: TextStyle(
                              fontFamily: 'Noto Sans',
                              color: DarkThemeColor.PRIMARY,
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
          /* Get.snackbar('????????? ??????', '????????? ???????????? ????????????.'); */
          print("login error");
        } else if (e.code == 'wrong-password') {
          /* Get.snackbar('????????? ??????', '??????????????? ?????? ?????????????????????.'); */
          print("login error");
        } else if (e.code == 'invalid-email') {
          /* Get.snackbar('????????? ??????', '????????? ????????? ???????????????.'); */
          print("login error");
        }
      }
    } else {
      /* Get.snackbar('????????? ??????', '???????????? ??????????????? ??????????????????.'); */
      print("login error");
    }
  }
}
