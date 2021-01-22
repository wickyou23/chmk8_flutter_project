import 'package:chkm8_app/enum/rating_type_enum.dart';
import 'package:chkm8_app/utils/constant.dart';
import 'package:chkm8_app/widgets/app_scaffold.dart';
import 'package:chkm8_app/widgets/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';

class MyRatingInformScreen extends StatelessWidget {
  static final routeName = '/MyRatingInformScreen';

  @override
  Widget build(BuildContext context) {
    RatingType type = context.routeArg as RatingType;

    return AppScaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CustomNavigationBar(
            navTitle: type.getMyTitle(),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 37),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 188,
                    child: AspectRatio(
                      aspectRatio: 565 / 499,
                      child: Image.asset(
                        'assets/images/bg_my_rating_inform.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  Text(
                    'You need to have at least 3 ratings to view the report',
                    textAlign: TextAlign.center,
                    style: context.theme.textTheme.headline5.copyWith(
                      fontSize: 16,
                      color: Constaint.defaultTextColor,
                    ),
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
