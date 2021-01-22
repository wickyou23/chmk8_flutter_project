import 'package:chkm8_app/screens/home_screen.dart';
import 'package:chkm8_app/utils/constant.dart';
import 'package:chkm8_app/widgets/app_scaffold.dart';
import 'package:chkm8_app/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';

class ScheduleInvitationConfirmScreen extends StatelessWidget {
  static final routeName = '/ScheduleInvitationConfirmScreen';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 37),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 192,
                child: AspectRatio(
                  aspectRatio: 575 / 476,
                  child: Image.asset(
                    'assets/images/bg_schedule_invitation_confirmation.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 33),
              Text(
                'Done and Done!\nYou\'ve set up a Mutual Rating for Mickey. You will receive a reminder to post your Rating within 24 hours after your date.',
                textAlign: TextAlign.center,
                style: context.theme.textTheme.headline5.copyWith(
                  fontSize: 16,
                  color: Constaint.defaultTextColor,
                ),
              ),
              SizedBox(height: 82),
              CustomButtonWidget(
                title: 'Got it',
                btnColor: Constaint.scheduleRatingColor,
                onPressed: () {
                  context.navigator.popUntil((route) {
                    return route.settings.name == HomeScreen.routeName;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
