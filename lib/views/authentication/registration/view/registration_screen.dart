import 'package:brilloconnetz_app/core/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart'; 
import '../../authentication.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

enum ScreenTab { emial, mobile }
FirebaseAuth auth = FirebaseAuth.instance;

class _RegistrationScreenState extends State<RegistrationScreen> {
  ScreenTab screenTab = ScreenTab.emial;
  bool isVisible = true;

  UserCredential? userCredential;

// email sign up validation
  final email = TextEditingController();
  final emailPassword = TextEditingController();
  bool _isEmailValide = false;
  bool _isEmailPasswordValide = false;

  // mobile sign up validation
  TextEditingController phonenumber = TextEditingController();
  final mobilePassword = TextEditingController();
  String initialCountry = 'NG';
  PhoneNumber number = PhoneNumber(isoCode: 'NG');
  var mobilenumber = '';
  bool _isPhoneNumberValide = false;
  bool _isMobilePasswordValide = false;

  String otpCode = '';
  String mobileVerificarionID = '';
  @override
  void dispose() {
    super.dispose();
    email.text = '';
    emailPassword.text = '';
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
                  'Sign Up',
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
                        controller: emailPassword,
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
                          errorBorder: const OutlineInputBorder(),
                          errorText: _isEmailPasswordValide
                              ? 'Password Can\'t Be Empty'
                              : null,
                        ),
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

                          emailPassword.text.isEmpty
                              ? _isEmailPasswordValide = true
                              : _isEmailPasswordValide = false;

                          if (email.text.isNotEmpty &&
                              emailPassword.text.isNotEmpty) {
                            User? user = FirebaseAuth.instance.currentUser;
                            FirebaseAuth auth = FirebaseAuth.instance;
                            UserCredential userCredential;

                            try {
                              userCredential =
                                  await auth.createUserWithEmailAndPassword(
                                      email: email.text,
                                      password: emailPassword.text);

                              if (user != null && !user.emailVerified) {
                                await user.sendEmailVerification();
                              }
                              AppDialog().showSnackBar(
                                  context, 'Check your mail to verify account');
                              email.text = '';
                              emailPassword.text = '';
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                AppDialog().showSnackBar(context,
                                    'The password provided is too weak.');
                              } else if (e.code == 'email-already-in-use') {
                                AppDialog().showSnackBar(context,
                                    'The account already exists for that email.');
                              }
                            } catch (e) {
                              print(e);
                              AppDialog()
                                  .showSnackBar(context, 'Invalid Input');
                            }
                          }
                        },
                      ),
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
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => MobileOtpScreen( mobilenumber: mobilenumber, mobileVerificarionID: mobileVerificarionID,),
                              //   ),
                              // );
                              await phonenumberauth(context);
                            }
                          }),
                    ],
                  ),
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     const Text('Phone Number'),
                  //     const SizedBox(height: 3.0),
                  //     InternationalPhoneNumberInput(
                  //       onInputChanged: (PhoneNumber number) {
                  //         // print(number.phoneNumber);
                  //         mobilenumber = number.phoneNumber!;
                  //         // print(mobilenumber);
                  //       },
                  //       onInputValidated: (bool value) {
                  //         // print(value);
                  //       },
                  //       selectorConfig: const SelectorConfig(
                  //         selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  //       ),
                  //       ignoreBlank: false,
                  //       autoValidateMode: AutovalidateMode.disabled,
                  //       selectorTextStyle: const TextStyle(color: Colors.black),
                  //       initialValue: number,
                  //       textFieldController: phonenumber,
                  //       formatInput: false,
                  //       keyboardType: const TextInputType.numberWithOptions(
                  //           signed: true, decimal: true),
                  //       inputBorder: const OutlineInputBorder(),
                  //       inputDecoration: InputDecoration(
                  //         hintText: 'Please enter phone number',
                  //         focusedBorder: const OutlineInputBorder(),
                  //         enabledBorder: const OutlineInputBorder(),
                  //         errorBorder: const OutlineInputBorder(),
                  //         errorText: _isPhoneNumberValide
                  //             ? 'Phone number Can\'t Be Empty'
                  //             : null,
                  //       ),
                  //       onSaved: (PhoneNumber number) {
                  //         // print('On Saved: $number');
                  //       },
                  //     ),
                  //     const SizedBox(
                  //       height: 30.0,
                  //     ),
                  //     const Text('Password'),
                  //     const SizedBox(height: 3.0),
                  //     TextField(
                  //       controller: mobilePassword,
                  //       obscureText: isVisible,
                  //       decoration: InputDecoration(
                  //         hintText: 'Please enter password',
                  //         suffixIcon: GestureDetector(
                  //           onTap: () {
                  //             setState(() {
                  //               isVisible = !isVisible;
                  //             });
                  //           },
                  //           child: Icon(
                  //             isVisible
                  //                 ? Icons.visibility_off
                  //                 : Icons.visibility_outlined,
                  //           ),
                  //         ),
                  //         focusedBorder: const OutlineInputBorder(),
                  //         enabledBorder: const OutlineInputBorder(),
                  //         errorBorder: const OutlineInputBorder(),
                  //         errorText: _isMobilePasswordValide
                  //             ? 'Password Can\'t Be Empty'
                  //             : null,
                  //       ),
                  //     ),
                  //     const SizedBox(
                  //       height: 50.0,
                  //     ),
                  //     AuthButton(
                  //         authText: 'Continue',
                  //         authButton: () async {
                  //           setState(() {});

                  //           phonenumber.text.isEmpty
                  //               ? _isPhoneNumberValide = true
                  //               : _isPhoneNumberValide = false;

                  //           mobilePassword.text.isEmpty
                  //               ? _isMobilePasswordValide = true
                  //               : _isMobilePasswordValide = false;

                  //           // Navigator.push(
                  //           //   context,
                  //           //   MaterialPageRoute(
                  //           //     builder: (context) => const MobileOtpScreen(),
                  //           //   ),
                  //           // );

                  //           if (mobilenumber.length == 14) {
                  //             // await auth.currentUser()
                  //             // ConfirmationResult confirmationResult =
                  //             //     await auth.signInWithPhoneNumber(
                  //             //         phonenumber.text,
                  //             //         RecaptchaVerifier(
                  //             //           container: 'recaptcha',
                  //             //           size: RecaptchaVerifierSize.compact,
                  //             //           theme: RecaptchaVerifierTheme.dark,
                  //             //         ));
                  //             // RecaptchaVerifier(
                  //             //   onSuccess: () => print('reCAPTCHA Completed!'),
                  //             //   onError: (FirebaseAuthException error) =>
                  //             //       print(error),
                  //             //   onExpired: () => print('reCAPTCHA Expired!'),
                  //             // );
                  //             // userCredential =
                  //             //     await confirmationResult.confirm('12345');
                  //             // print('object');
                  //             // await phonenumberauth(context);
                  //           }
                  //         }),
                  //   ],
                  // ),
                ],
                const SizedBox(
                  height: 30.0,
                ),
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: 'Already have an account?',
                        style: AppTextStyle.h1.copyWith(
                          fontSize: 15.0,
                          color: AppColor.gray,
                        ),
                        children: [
                          TextSpan(
                            text: ' Log In',
                            style: AppTextStyle.h1.copyWith(
                              fontSize: 15.0,
                              color: AppColor.kprimary,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                          ),
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
          AppDialog()
              .showSnackBar(context, 'The provided phone number is not valid.');
        } else {
          print('--------------------------2------------');
          print(e);
          print('--------------------------2------------');
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
         mobileVerificarionID = verificationId;
         print(verificationId);
          print('--------------------------22------------');
         print(mobileVerificarionID);


        // Update the UI - wait for the user to enter the SMS code

        // Create a PhoneAuthCredential with the code
        // PhoneAuthCredential credential = PhoneAuthProvider.credential(
        //     verificationId: verificationId, smsCode: otpCode);

        // Sign the user in (or link) with the credential
        // await auth.signInWithCredential(credential);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  MobileOtpScreen( mobilenumber: mobilenumber, mobileVerificarionID: mobileVerificarionID,),
          ),
        );

        AppDialog().showSnackBar(context, 'text');
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print('-------------------end-------------------');
      },
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
