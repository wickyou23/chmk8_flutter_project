import 'package:chkm8_app/screens/home_screen.dart';
import 'package:chkm8_app/utils/constant.dart';
import 'package:chkm8_app/widgets/app_scaffold.dart';
import 'package:chkm8_app/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';

class OverallRatingNotHappen extends StatelessWidget {
  static final routeName = '/OverallRatingNotHappen';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AppScaffold(
        body: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              SizedBox(height: 90),
              Image.asset(
                'assets/images/bg_overall_not_happen.png',
                width: 254,
                height: 254 * 0.638269987,
              ),
              SizedBox(height: 45),
              Text(
                'Hope things work out next time!',
                style: context.theme.textTheme.headline5.copyWith(
                  fontSize: 21,
                  color: Constaint.defaultTextColor,
                ),
              ),
              SizedBox(height: 33),
              CustomButtonWidget(
                title: 'Thanks!',
                btnColor: Constaint.rateYourDateColor,
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
    );
  }
}
