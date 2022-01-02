import 'package:brilloconnetz_app/core/utils/utils.dart'; 
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  AuthButton({required this.authText, required this.authButton});

  final String authText;
  final VoidCallback authButton;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          authText,
          style: AppTextStyle.h1.copyWith(
            color: AppColor.kprimary,
            fontSize: 30.0,
          ),
        ),
        InkWell(
          onTap: authButton,
          child: Container(
            decoration: const BoxDecoration(
              color: AppColor.kprimary,
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(15),
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
