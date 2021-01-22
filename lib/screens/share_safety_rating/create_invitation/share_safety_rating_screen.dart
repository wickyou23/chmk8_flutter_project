import 'package:chkm8_app/screens/share_safety_rating/accept_invitation/accept_invitation_screen.dart';
import 'package:chkm8_app/screens/share_safety_rating/create_invitation/create_invitation_code_screen.dart';
import 'package:chkm8_app/widgets/app_scaffold.dart';
import 'package:chkm8_app/widgets/custom_button_widget.dart';
import 'package:chkm8_app/widgets/custom_navigation_bar.dart';
import 'package:chkm8_app/widgets/helping_popup_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';

class ShareSafetyRatingScreen extends StatelessWidget {
  static final routeName = '/ShareSafetyRatingScreeb';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          CustomNavigationBar(
            navTitle: 'Share Safety Rating',
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
                  'Share your Safety Rating and invite your date to do the same.',
                  textAlign: TextAlign.center,
                  style: context.theme.textTheme.headline5.copyWith(
                    fontSize: 16,
                    color: ColorExt.colorWithHex(0x4F4F4F),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40),
                CustomButtonWidget(
                  wTitle: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Create Invitation',
                        style: context.theme.textTheme.headline5.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 5),
                      ImageIcon(
                        AssetImage('assets/images/ic_arrow_right.png'),
                        size: 24,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  width: 264,
                  height: 63,
                  radius: 18,
                  onPressed: () {
                    context.navigator
                        .pushNamed(CreateInvitationCodeScreen.routeName);
                  },
                ),
                SizedBox(height: 8),
                Text(
                  'Set up a mutual sharing of\nSafety Ratings.',
                  textAlign: TextAlign.center,
                  style: context.theme.textTheme.headline5.copyWith(
                    fontSize: 13,
                    color: ColorExt.colorWithHex(0x4F4F4F),
                  ),
                ),
                SizedBox(height: 30),
                CustomButtonWidget(
                  wTitle: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Accept Invitation',
                        style: context.theme.textTheme.headline5.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 5),
                      ImageIcon(
                        AssetImage('assets/images/ic_arrow_right.png'),
                        size: 24,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  width: 264,
                  height: 63,
                  radius: 18,
                  onPressed: () {
                    context.navigator
                        .pushNamed(AcceptInvitationScreen.routeName);
                  },
                ),
                SizedBox(height: 8),
                Text(
                  'Agree to a mutual sharing\nof Safety Ratings.',
                  textAlign: TextAlign.center,
                  style: context.theme.textTheme.headline5.copyWith(
                    fontSize: 13,
                    color: ColorExt.colorWithHex(0x4F4F4F),
                  ),
                ),
                Expanded(child: Container()),
                CupertinoButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ImageIcon(
                        AssetImage('assets/images/ic_help_circle.png'),
                        size: 24,
                        color: ColorExt.colorWithHex(0x333333),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'How does this help?',
                        textAlign: TextAlign.center,
                        style: context.theme.textTheme.headline5.copyWith(
                          fontSize: 13,
                          color: ColorExt.colorWithHex(0x4F4F4F),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    context.showPopup(
                      child: HelpingPopupWidget(
                        messages: [
                          'Don\'t waste your time wondering if someone\'s safe - get their rating already!',
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: (context.media.viewPadding.bottom == 0
                      ? 10
                      : context.media.viewPadding.bottom),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
