import 'dart:math';

import 'package:chkm8_app/bloc/shared_safety/shared_safety_bloc.dart';
import 'package:chkm8_app/bloc/shared_safety/shared_safety_state.dart';
import 'package:chkm8_app/enum/home_tab_enum.dart';
import 'package:chkm8_app/enum/rating_type_enum.dart';
import 'package:chkm8_app/models/rating_review_object.dart';
import 'package:chkm8_app/screens/home_screen.dart';
import 'package:chkm8_app/services/notification_service.dart';
import 'package:chkm8_app/utils/constant.dart';
import 'package:chkm8_app/widgets/app_scaffold.dart';
import 'package:chkm8_app/widgets/custom_button_widget.dart';
import 'package:chkm8_app/widgets/custom_navigation_bar.dart';
import 'package:chkm8_app/widgets/star_rating_widget.dart';
import 'package:chkm8_app/widgets/star_review_widget.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SafetyRatingReportScreen extends StatelessWidget {
  static final routeName = '/SafetyRatingReportScreen';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AppScaffold(
        body: BlocBuilder<SharedSafetyBloc, SharedSafetyState>(
          builder: (ctx, state) {
            RatingReviewObject obj;
            if (state is SharedSafetyReviewState) {
              obj = state.rating.copyWith(type: RatingType.safety);
            }

            return Stack(
              children: <Widget>[
                CustomNavigationBar(
                  navTitle: 'Safety Rating',
                  isShowBack: false,
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: CustomNavigationBar.heightNavBar +
                        context.media.viewPadding.top,
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: (context.isSmallDevice) ? 0 : 33),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          (obj.code.isEmpty)
                              ? 'This is the Safety Rating of the person that you share the code with'
                              : 'This is the Safety Rating of the person that you share the code ${obj.code} with',
                          textAlign: TextAlign.center,
                          style: context.theme.textTheme.headline5.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Constaint.defaultTextColor,
                          ),
                        ),
                      ),
                      SizedBox(height: (context.isSmallDevice) ? 16 : 33),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          obj.displayStarStatus,
                          textAlign: TextAlign.center,
                          style: context.theme.textTheme.headline5.copyWith(
                            fontSize: 21,
                            color: Constaint.defaultTextColor,
                          ),
                        ),
                      ),
                      SizedBox(height: (context.isSmallDevice) ? 10 : 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: StarRatingWidget(
                          starScore: obj.star,
                        ),
                      ),
                      SizedBox(height: (context.isSmallDevice) ? 8 : 16),
                      Text(
                        obj.star.toCSStringAsFixed(1),
                        textAlign: TextAlign.center,
                        style: context.theme.textTheme.headline5.copyWith(
                          fontSize: 27,
                          color: Constaint.defaultTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        obj.displayBaseOn,
                        textAlign: TextAlign.center,
                        style: context.theme.textTheme.headline5.copyWith(
                          fontSize: 16,
                          color: Constaint.defaultTextColor,
                        ),
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 5.0,
                        ),
                        child: StarReviewWidget(
                          type: RatingType.safety,
                        ),
                      ),
                      SizedBox(height: (context.isSmallDevice) ? 16 : 20),
                      Text(
                        obj.displayRatingDate,
                        textAlign: TextAlign.center,
                        style: context.theme.textTheme.headline5.copyWith(
                          fontSize: 13,
                          color: Constaint.defaultTextColor,
                        ),
                      ),
                      SizedBox(height: (context.isSmallDevice) ? 8 : 17),
                      Expanded(child: Container()),
                      CustomButtonWidget(
                        title: 'Go to Home',
                        onPressed: () {
                          NotificationService().add(
                            NotificationName.HOME_SCREEN_CHANGE_TAB,
                            value: HomeTab.dashboard,
                          );
                          Future.delayed(Duration(milliseconds: 100), () {
                            context.navigator.popUntil((route) {
                              return route.settings.name ==
                                  HomeScreen.routeName;
                            });
                          });
                        },
                      ),
                      SizedBox(
                          height: max(context.media.viewPadding.bottom, 16)),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
