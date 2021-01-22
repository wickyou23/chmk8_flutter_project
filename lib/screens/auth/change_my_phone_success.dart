import 'package:chkm8_app/enum/home_tab_enum.dart';
import 'package:chkm8_app/services/notification_service.dart';
import 'package:chkm8_app/widgets/app_scaffold.dart';
import 'package:chkm8_app/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';

class ChangeMyPhoneSuccess extends StatelessWidget {
  static final routeName = '/ChangeMyPhoneSuccess';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 110),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Image.asset(
              'assets/images/bg_change_my_phone_success.png',
              width: 208,
              height: 208 * 0.8976,
            ),
            SizedBox(height: 77),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'You have successfully changed your phone number. Tap "View Profile" for details.',
                textAlign: TextAlign.center,
                style: context.theme.textTheme.headline5.copyWith(
                  fontSize: 16,
                  color: ColorExt.colorWithHex(0x333333),
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(height: 45),
            CustomButtonWidget(
              width: 238,
              title: 'View Profile',
              onPressed: () {
                context.navigator.pop();
              },
            ),
            SizedBox(height: 19),
            CustomButtonWidget(
              width: 238,
              title: 'Back to Home',
              type: CustomButtonType.line,
              onPressed: () {
                NotificationService().add(
                  NotificationName.HOME_SCREEN_CHANGE_TAB,
                  value: HomeTab.dashboard,
                );
                Future.delayed(Duration(milliseconds: 100), () {
                  context.navigator.pop();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
