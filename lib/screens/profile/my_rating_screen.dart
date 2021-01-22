import 'dart:math';

import 'package:chkm8_app/enum/rating_type_enum.dart';
import 'package:chkm8_app/models/rating_review_object.dart';
import 'package:chkm8_app/utils/constant.dart';
import 'package:chkm8_app/widgets/app_scaffold.dart';
import 'package:chkm8_app/widgets/custom_navigation_bar.dart';
import 'package:chkm8_app/widgets/star_rating_widget.dart';
import 'package:chkm8_app/widgets/star_review_widget.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';

class MyRatingScreen extends StatelessWidget {
  static final routeName = '/MyRatingScreen';

  final RatingReviewObject ratingReviewObj;

  MyRatingScreen({
    @required this.ratingReviewObj,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Stack(
        children: <Widget>[
          CustomNavigationBar(
            navTitle: this.ratingReviewObj.type.getMyTitle(),
          ),
          Container(
            padding: EdgeInsets.only(
              top: CustomNavigationBar.heightNavBar +
                  context.media.viewPadding.top,
            ),
            child: Column(
              children: <Widget>[
                SizedBox(height: (context.isSmallDevice) ? 20 : 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    this.ratingReviewObj.displayStarStatus,
                    textAlign: TextAlign.center,
                    style: context.theme.textTheme.headline5.copyWith(
                      fontSize: 21,
                      color: Constaint.defaultTextColor,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: StarRatingWidget(
                    starScore: this.ratingReviewObj.star,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  this.ratingReviewObj.star.toCSStringAsFixed(1),
                  textAlign: TextAlign.center,
                  style: context.theme.textTheme.headline5.copyWith(
                    fontSize: 27,
                    color: Constaint.defaultTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  this.ratingReviewObj.displayBaseOn,
                  textAlign: TextAlign.center,
                  style: context.theme.textTheme.headline5.copyWith(
                    fontSize: 16,
                    color: Constaint.defaultTextColor,
                  ),
                ),
                SizedBox(height: (context.isSmallDevice) ? 35 : 70),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 5.0,
                  ),
                  child: StarReviewWidget(
                    type: this.ratingReviewObj.type,
                  ),
                ),
                Expanded(child: Container()),
                Text(
                  this.ratingReviewObj.displayRatingDate,
                  textAlign: TextAlign.center,
                  style: context.theme.textTheme.headline5.copyWith(
                    fontSize: 13,
                    color: Constaint.defaultTextColor,
                  ),
                ),
                SizedBox(height: max(20, context.media.viewPadding.bottom)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
