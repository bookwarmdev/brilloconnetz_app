import 'package:brilloconnetz_app/core/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../home.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

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
                 SizedBox(
                  height: 60.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    child: Text('Profile', style: AppTextStyle.h1.copyWith(
                      color: AppColor.kprimaryTin,
                      fontSize: 25.0,
                    )),
                  ),
                ),
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
                        AppColor.white,
                        AppColor.kprimaryTin,
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/Container.png'),
                        radius: 80.0,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'User1234',
                        style: AppTextStyle.h1.copyWith(color: AppColor.white),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                    ],
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
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const UserProfile(
                      label: 'Password',
                      text: '**************',
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                  ] else ...[
                    UserProfile(
                      label: 'Mobile Number',
                      text: userData!.phoneNumber ?? '',
                    ), 
                  ], 
                   const UserProfile(
                    label: 'Interest',
                    text: 'Swimming',
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
