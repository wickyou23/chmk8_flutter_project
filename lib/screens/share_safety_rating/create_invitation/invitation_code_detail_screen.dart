import 'package:chkm8_app/screens/home_screen.dart';
import 'package:chkm8_app/screens/share_safety_rating/create_invitation/invitation_code_countdown_screen.dart';
import 'package:chkm8_app/utils/constant.dart';
import 'package:chkm8_app/widgets/app_scaffold.dart';
import 'package:chkm8_app/widgets/custom_button_widget.dart';
import 'package:chkm8_app/widgets/custom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';
import 'package:flutter/services.dart';

class InvitationCodeDetailScreen extends StatefulWidget {
  static final routeName = '/InvitationCodeDetailScreen';

  @override
  _InvitationCodeDetailScreenState createState() =>
      _InvitationCodeDetailScreenState();
}

class _InvitationCodeDetailScreenState
    extends State<InvitationCodeDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Stack(
        children: <Widget>[
          CustomNavigationBar(
            navTitle: 'Share Safety\nRating',
          ),
          Container(
            padding: EdgeInsets.only(
              top: CustomNavigationBar.heightNavBar +
                  context.media.viewPadding.top,
              left: 20,
              right: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 46),
                Text(
                  'Share the invitation code with your date via SMS, messenger etc.',
                  textAlign: TextAlign.center,
                  style: context.theme.textTheme.headline5.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorExt.colorWithHex(0x4F4F4F),
                  ),
                ),
                SizedBox(height: 26),
                Text(
                  '123456',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Moderat',
                    fontSize: 40,
                    letterSpacing: 5,
                  ),
                ),
                SizedBox(height: 37),
                CustomButtonWidget(
                  wTitle: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Copy Code',
                        style: context.theme.textTheme.headline5.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      ImageIcon(
                        AssetImage('assets/images/ic_copy_code.png'),
                        size: 24,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  width: 257,
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: 'My invitation code: 123456'),
                    );
                    context.navigator.pushReplacementNamed(
                      InvitationCodeCountDownScreen.routeName,
                    );
                  },
                ),
                SizedBox(height: 30),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Text(
                    'Cancel',
                    style: context.theme.textTheme.headline5.copyWith(
                      fontSize: 18,
                      color: Constaint.defaultTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    context.navigator.popUntil(
                      (route) => route.settings.name == HomeScreen.routeName,
                    );
                  },
                ),
                Expanded(child: Container()),
                Text(
                  'Pro Tip:',
                  style: context.theme.textTheme.headline5.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Constaint.mainColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Your friend needs the ChkM8 app to accept the invitation',
                  textAlign: TextAlign.center,
                  style: context.theme.textTheme.headline5.copyWith(
                    fontSize: 16,
                    color: ColorExt.colorWithHex(0x333333),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          )
        ],
      ),
    );
  }
}
