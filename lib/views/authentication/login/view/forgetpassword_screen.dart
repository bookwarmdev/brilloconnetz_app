import 'package:brilloconnetz_app/core/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  stops: [
                    0.0,
                    1.0,
                  ],
                  colors: [
                    AppColor.kprimary,
                    AppColor.kprimaryTin,
                  ],
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.navigate_before),
                    color: AppColor.white,
                  ),
                  SizedBox(
                    height: 60.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      child: Text('Password',
                          style: AppTextStyle.h1.copyWith(
                            color: AppColor.white,
                            fontSize: 25.0,
                          )),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Text(
                    'Reset Password',
                    style: AppTextStyle.h1.copyWith(
                      fontSize: 20.0,
                    ),
                  ),
                  TextFormField(
                    controller: email,
                    style: const TextStyle(color: AppColor.kprimary),
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      icon: Icon(
                        Icons.mail,
                        color: AppColor.kprimaryTin,
                      ),
                      errorStyle: TextStyle(
                        color: Colors.red,
                      ),
                      labelStyle: TextStyle(
                        color: AppColor.gray,
                      ),
                      hintStyle: TextStyle(
                        color: AppColor.kprimaryTin,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColor.kprimaryTin,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColor.kprimaryTin,
                        ),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColor.red,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () async {
                      setState(() {});

                      FirebaseAuth auth = FirebaseAuth.instance;
                      try {
                        if (email.text.isEmpty) {
                          AppDialog()
                              .showSnackBar(context, 'input field empty');
                        } else {
                          await auth.sendPasswordResetEmail(email: email.text);
                          AppDialog().showSnackBar(context, 'check your email');
                          Navigator.pop(context);
                        }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          AppDialog().showSnackBar(context,
                              'There is no user record corresponding to this identifier');
                        }
                      } catch (e) {
                        AppDialog().showSnackBar(context, 'Invalid email');
                        // print(e);
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: AppColor.kprimaryTin.withOpacity(0.1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Reset Password',
                        style: AppTextStyle.P.copyWith(
                          fontStyle: FontStyle.normal,
                          color: AppColor.kprimaryTin,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
