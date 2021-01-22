import 'package:chkm8_app/screens/home_screen.dart';
import 'package:chkm8_app/utils/constant.dart';
import 'package:chkm8_app/widgets/app_scaffold.dart';
import 'package:chkm8_app/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';

class RatingSuccessScreen extends StatelessWidget {
  static final routeName = '/RatingSuccessScreen';

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
                width: 199,
                child: AspectRatio(
                  aspectRatio: 598 / 579,
                  child: Image.asset(
                    'assets/images/bg_rating_success.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 28),
              Text(
                'Success!',
                textAlign: TextAlign.center,
                style: context.theme.textTheme.headline5.copyWith(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Constaint.defaultTextColor,
                ),
              ),
              SizedBox(height: 17),
              Text(
                'Thank you for submitting your rating. You have made the ChkM8 community safer and smarter. Because there\'s safety in numbers',
                textAlign: TextAlign.center,
                style: context.theme.textTheme.headline5.copyWith(
                  fontSize: 16,
                  color: Constaint.defaultTextColor,
                ),
              ),
              SizedBox(height: 61),
              CustomButtonWidget(
                title: 'Great',
                btnColor: Constaint.rateYourDateColor,
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
