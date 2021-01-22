import 'package:chkm8_app/screens/auth/verification_code_screen.dart';
import 'package:chkm8_app/screens/home_screen.dart';
import 'package:chkm8_app/widgets/app_scaffold.dart';
import 'package:chkm8_app/widgets/custom_button_widget.dart';
import 'package:chkm8_app/widgets/custom_navigation_bar.dart';
import 'package:chkm8_app/widgets/custom_textformfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';

class ChangeMyPhoneScreen extends StatefulWidget {
  static final routeName = '/ChangeMyPhoneScreen';

  @override
  _ChangeMyPhoneScreenState createState() => _ChangeMyPhoneScreenState();
}

class _ChangeMyPhoneScreenState extends State<ChangeMyPhoneScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Stack(
        children: <Widget>[
          CustomNavigationBar(
            navTitle: 'Change My Phone',
          ),
          Container(
            padding: EdgeInsets.only(
              top: CustomNavigationBar.heightNavBar +
                  context.media.viewPadding.top,
              left: 20,
              right: 20,
            ),
            child: Form(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 75),
                  CustomTextFormField(
                    title: 'Enter your old phone number',
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 27),
                  CustomTextFormField(
                    title: 'Enter the new phone number',
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 27),
                  CustomButtonWidget(
                    title: 'Send',
                    onPressed: () {
                      context.navigator.pushReplacementNamed(
                        VerificationCodeScreen.routeName,
                        arguments: VerificationCodeType.changePhone,
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  CupertinoButton(
                    child: Text(
                      'Cancel',
                      style: context.theme.textTheme.headline5.copyWith(
                        color: ColorExt.colorWithHex(0x4F4F4F),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      context.navigator.popUntil(
                        (route) => route.settings.name == HomeScreen.routeName,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
