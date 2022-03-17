import 'package:brilloconnetz_app/core/utils/utils.dart';
import 'package:brilloconnetz_app/views/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../authentication.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

enum ScreenTab { emial, mobile }

class _LoginScreenState extends State<LoginScreen> {
  ScreenTab screenTab = ScreenTab.emial;
  bool isVisible = true;
  TextEditingController phonenumber = TextEditingController();
  String initialCountry = 'NG';
  PhoneNumber number = PhoneNumber(isoCode: 'NG');

  final email = TextEditingController();
  final password = TextEditingController();
  var mobilenumber = '';
  final mobilePassword = TextEditingController();

  bool _isEmailValide = false;
  bool _isPasswordValide = false;
  bool _isPhoneNumberValide = false;
  bool _isMobilePasswordValide = false;

  void fech_otp() {
    Future<void> phonenumberauth(BuildContext context) async {
      return await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: mobilenumber,
        // timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Sign the user in (or link) with the auto-generated credential
          await auth.signInWithCredential(credential);
          print('-----------------1---------------------');
          AppDialog().showSnackBar(
              context, 'Verification Code sent on the phone number');
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            AppDialog().showSnackBar(
                context, 'The provided phone number is not valid.');
          } else {
            print('--------------------------2------------');
            print(e);
            print('--------------------------2------------');
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );

          AppDialog().showSnackBar(context, 'Success');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('-------------------end-------------------');
        },
      );
    }
  }

  @override
  void dispose() {
    super.dispose();

    email.text = '';
    password.text = '';
    mobilenumber = '';
    mobilePassword.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30.0,
                ),
                Text(
                  'Log In',
                  style: AppTextStyle.h1.copyWith(
                    color: AppColor.kprimary,
                    fontSize: 25.0,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    AuthTab(
                      display: screenTab == ScreenTab.emial ? true : false,
                      text: 'Email',
                      onTap: () {
                        setState(() {
                          screenTab = ScreenTab.emial;
                        });
                      },
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    AuthTab(
                      display: screenTab == ScreenTab.mobile ? true : false,
                      text: 'Mobile',
                      onTap: () {
                        setState(() {
                          screenTab = ScreenTab.mobile;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                if (screenTab == ScreenTab.emial) ...[
                  Column(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgetPasswordScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'forget password',
                              style: AppTextStyle.P.copyWith(
                                  color: AppColor.gray, fontSize: 15.0),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50.0,
                      ),
                      AuthButton(
                          authText: 'Continue',
                          authButton: () async {
                            setState(() {});

                            email.text.isEmpty
                                ? _isEmailValide = true
                                : _isEmailValide = false;

                            password.text.isEmpty
                                ? _isPasswordValide = true
                                : _isPasswordValide = false;

                            UserCredential userCredential;
                            FirebaseAuth auth = FirebaseAuth.instance;

                            if (email.text.isNotEmpty) {
                              try {
                                userCredential =
                                    await auth.signInWithEmailAndPassword(
                                        email: email.text,
                                        password: password.text);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return const HomeScreen();
                                  }),
                                );
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'user-not-found') {
                                  AppDialog().showSnackBar(
                                      context, 'No user found for that email.');
                                } else if (e.code == 'wrong-password') {
                                  AppDialog().showSnackBar(context,
                                      'Wrong password provided for that user.');
                                } else {
                                  // print('------------------');
                                  // print(e);
                                  // print('------------------');
                                }
                              }
                            }
                          }),
                    ],
                  ),
                ] else if (screenTab == ScreenTab.mobile) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Phone Number'),
                      const SizedBox(height: 3.0),
                      InternationalPhoneNumberInput(
                        onInputChanged: (PhoneNumber number) {
                          // print(number.phoneNumber);
                          mobilenumber = number.phoneNumber!;
                          print(mobilenumber);
                        },
                        onInputValidated: (bool value) {
                          print(value);
                        },
                        selectorConfig: const SelectorConfig(
                          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                        ),
                        ignoreBlank: false,
                        autoValidateMode: AutovalidateMode.disabled,
                        selectorTextStyle: const TextStyle(color: Colors.black),
                        initialValue: number,
                        textFieldController: phonenumber,
                        formatInput: false,
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        inputBorder: const OutlineInputBorder(),
                        inputDecoration: InputDecoration(
                          hintText: 'Please enter phone number',
                          focusedBorder: const OutlineInputBorder(),
                          enabledBorder: const OutlineInputBorder(),
                          errorBorder: const OutlineInputBorder(),
                          errorText: _isPhoneNumberValide
                              ? 'Phone number Can\'t Be Empty'
                              : null,
                        ),
                        onSaved: (PhoneNumber number) {
                          // print('On Saved: $number');
                        },
                      ),
                      const SizedBox(
                        height: 80.0,
                      ),
                      const SizedBox(
                        height: 50.0,
                      ),
                      AuthButton(
                          authText: 'Continue',
                          authButton: () async {
                            setState(() {});

                            phonenumber.text.isEmpty
                                ? _isPhoneNumberValide = true
                                : _isPhoneNumberValide = false;

                            if (mobilenumber.length == 14) {
                              fech_otp();
                            }
                          }),
                    ],
                  ),
                ],
                const SizedBox(
                  height: 30.0,
                ),
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: 'Don’t have an account?',
                        style: AppTextStyle.h1.copyWith(
                          fontSize: 15.0,
                          color: AppColor.gray,
                        ),
                        children: [
                          TextSpan(
                            text: ' Sign Up',
                            style: AppTextStyle.h1.copyWith(
                              fontSize: 15.0,
                              color: AppColor.kprimary,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RegistrationScreen(),
                                  ),
                                );
                              },
                          )
                        ]),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AuthTab extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool display;
  const AuthTab({
    Key? key,
    required this.text,
    required this.onTap,
    required this.display,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: display == true
            ? const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 3,
                    color: AppColor.gray,
                  ),
                ),
              )
            : const BoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 3.0),
          child: Container(
            margin: const EdgeInsets.only(bottom: 2.0),
            child: Text(
              text,
              style: AppTextStyle.h1.copyWith(
                color: AppColor.black,
                fontSize: 17.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
