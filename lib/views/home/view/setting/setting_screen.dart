import 'package:brilloconnetz_app/core/utils/utils.dart';
import 'package:brilloconnetz_app/views/authentication/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  late User? userData = auth.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  child: SizedBox(
                    height: 60.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      child: Text('Setting & Privacy',
                          style: AppTextStyle.h1.copyWith(
                            color: AppColor.white,
                            fontSize: 25.0,
                          )),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  if (userData!.email != null) ...[
                    UserProfile(
                      label: 'Email',
                      text: userData!.email ?? '',
                      onTap: (){},
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    UserProfile(
                      label: 'Password',
                      text: '**************',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgetPasswordScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                  ] else ...[
                    UserProfile(
                      label: 'Mobile Number',
                      text: userData!.phoneNumber ?? '',
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                  ],
                  const UserProfile(
                    label: 'Interest',
                    text: 'Swimming',
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {});
                      try {
                        auth.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      } catch (e) {
                        print(e);
                      }
                    },
                    icon: const Icon(
                      Icons.login_sharp,
                      color: AppColor.kprimaryTin,
                    ),
                    label: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 7.0),
                      child: Text(
                        'Log Out',
                        style: AppTextStyle.P.copyWith(
                          fontStyle: FontStyle.normal,
                          color: AppColor.kprimaryTin,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: AppColor.kprimaryTin.withOpacity(0.1),
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

class UserProfile extends StatelessWidget {
  final String label;
  final String text;
  final VoidCallback? onTap;
  const UserProfile({
    Key? key,
    required this.label,
    required this.text,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style:
                AppTextStyle.h1.copyWith(fontSize: 17.0, color: AppColor.gray)),
        Row(
          children: [
            Text(
              text,
              style: AppTextStyle.P.copyWith(fontSize: 16.0),
            ),
            IconButton(
              onPressed: onTap,
              icon: const Icon(Icons.navigate_next),
            )
          ],
        )
      ],
    );
  }
}

// class EditSetting extends StatelessWidget {
//   const EditSetting({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       onPressed: () {
//         Navigator.push(context, MaterialPageRoute(builder: (context) => const EditSettingScreen(),),);
//       },
//       icon: const Icon(Icons.navigate_next),
//     );
//   }
// }
