import 'package:brilloconnetz_app/core/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class EditSettingScreen extends StatefulWidget {
  const EditSettingScreen({Key? key}) : super(key: key);

  @override
  _EditSettingScreenState createState() => _EditSettingScreenState();
}

class _EditSettingScreenState extends State<EditSettingScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  late User? userDate = auth.currentUser;

  TextEditingController email = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  final password = TextEditingController();
  final interest = TextEditingController();

  bool isVisible = false;
  bool _isEmailValide = false;
  bool _isMobileNumberValide = false;
  bool _isPasswordValide = false;
  bool _isInterestValide = false;

  @override
  Widget build(BuildContext context) {
    email.text = userDate!.email.toString();
    mobileNumber.text = userDate!.phoneNumber ?? '';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                        child: Text('Edit Setting & Privacy',
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
                height: 40.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Email'),
                    const SizedBox(
                      height: 3.0,
                    ),
                    TextField(
                      controller: email,
                      decoration: InputDecoration(
                        hintText: 'Please enter email',
                        focusedBorder: const OutlineInputBorder(),
                        enabledBorder: const OutlineInputBorder(),
                        errorBorder: const OutlineInputBorder(),
                        errorText:
                            _isEmailValide ? 'Email Can\'t Be Empty' : null,
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    const Text('Mobile Number'),
                    const SizedBox(
                      height: 3.0,
                    ),
                    TextField(
                      controller: mobileNumber, 
                      decoration: InputDecoration(
                        hintText: 'Please enter mobile number',
                        focusedBorder: const OutlineInputBorder(),
                        enabledBorder: const OutlineInputBorder(),
                        errorBorder: const OutlineInputBorder(),
                        errorText: _isMobileNumberValide
                            ? 'Mobile Number Can\'t Be Empty'
                            : null,
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    const Text('Password'),
                    const SizedBox(
                      height: 3.0,
                    ),
                    TextField(
                      controller: password,
                      obscureText: isVisible,
                      decoration: InputDecoration(
                        hintText: 'Please enter password',
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              isVisible = !isVisible;
                            });
                          },
                          child: Icon(
                            isVisible
                                ? Icons.visibility_off
                                : Icons.visibility_outlined,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(),
                        enabledBorder: const OutlineInputBorder(),
                        errorBorder: const UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColor.black, width: 2),
                        ),
                        errorText: _isPasswordValide
                            ? 'Password Can\'t Be Empty'
                            : null,
                      ),
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () async {
                          setState(() {});

                          try {
                            // PhoneAuthCredential phoneNumber;
                            // phoneNumber = PhoneAuthProvider.credential(
                            //     verificationId: mobileNumber.text, smsCode: '');

                            userDate!.updateEmail(email.text);
                            // userDate!.updatePhoneNumber(phoneNumber);
                            userDate!.updatePassword(password.text);

                            Navigator.pop(context);
                          } catch (e) {
                            print(e);
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor:
                              AppColor.kprimaryTin.withOpacity(0.1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Resset Detils',
                            style: AppTextStyle.P.copyWith(
                              fontStyle: FontStyle.normal,
                              color: AppColor.kprimaryTin,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
