import 'package:brilloconnetz_app/core/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import '../../authentication.dart';

// class MobileOtpScreen extends StatefulWidget {
//   var mobilenumber;
//   MobileOtpScreen({Key? key, required this.mobilenumber}) : super(key: key);

//   @override
//   _MobileOtpScreenState createState() => _MobileOtpScreenState();
// }

// class _MobileOtpScreenState extends State<MobileOtpScreen> {
class MobileOtpScreen extends StatelessWidget {
  var mobilenumber;
  var mobileVerificarionID;
  MobileOtpScreen({this.mobilenumber, required this.mobileVerificarionID});

  String otpCode = '';
  bool _isMobileOtpValide = false;

  FirebaseAuth auth = FirebaseAuth.instance;
  late UserCredential userCredential;

  @override
  Widget build(BuildContext context) {
    void signInWithPhoneAuthCredential(
        PhoneAuthCredential phoneAuthCredential) async {
      try {
        final authCredential =
            await auth.signInWithCredential(phoneAuthCredential);

        if (authCredential.user != null) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()));
        }
      } on FirebaseAuthException catch (e) {
        print(e);
      }
    }

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
                      child: Text('verify OTP',
                          style: AppTextStyle.h1.copyWith(
                            color: AppColor.white,
                            fontSize: 25.0,
                          )),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30.0,
                      ),
                      const Text(' verify OTP'),
                      const SizedBox(
                        height: 3.0,
                      ),
                      OTPTextField(
                        length: 6,
                        width: MediaQuery.of(context).size.width,
                        textFieldAlignment: MainAxisAlignment.spaceAround,
                        fieldWidth: 45,
                        fieldStyle: FieldStyle.box,
                        outlineBorderRadius: 17,
                        style: const TextStyle(fontSize: 13),
                        onChanged: (pin) {
                          otpCode = pin;
                          // print(otpCode);
                        },
                        onCompleted: (pin) {
                          otpCode = pin;
                          // print(otpCode);
                        },
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        _isMobileOtpValide ? 'Email Can\'t Be Empty' : ' ',
                        style: AppTextStyle.h1.copyWith(
                          color: AppColor.red,
                          fontSize: 12.0,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: mobilenumber,
                            timeout: const Duration(seconds: 60),
                            verificationCompleted:
                                (PhoneAuthCredential credential) async {
                              await auth.signInWithCredential(credential);
                              print('-----------------1---------------------');
                              AppDialog().showSnackBar(context,
                                  'Verification Code sent on the phone number');
                            },
                            verificationFailed: (FirebaseAuthException e) {},
                            codeSent:
                                (String verificationId, int? resendToken) {
                              mobileVerificarionID = verificationId;
                            },
                            codeAutoRetrievalTimeout:
                                (String verificationId) {},
                          );
                        },
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  AuthButton(
                      authText: 'verify',
                      authButton: () async {
                        // setState(() {
                        // });
                        otpCode.isEmpty
                            ? _isMobileOtpValide = false
                            : _isMobileOtpValide = true;

                        if (otpCode.length == 6) {
                          // await phonenumberauth(context);
                          PhoneAuthCredential phoneAuthCredential =
                              PhoneAuthProvider.credential(
                                  verificationId: mobileVerificarionID,
                                  smsCode: otpCode);

                          signInWithPhoneAuthCredential(phoneAuthCredential);
                        }
                      }),
                  Container(),
                ],
              ),
            ),
          ],
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
        // Update the UI - wait for the user to enter the SMS code
        // Create a PhoneAuthCredential with the code
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: otpCode);
        // Sign the user in (or link) with the credential
        await auth.signInWithCredential(credential);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
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
