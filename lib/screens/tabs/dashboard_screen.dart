import 'package:chkm8_app/screens/rate_your_date/rate_dashboard_screen.dart';
import 'package:chkm8_app/screens/schedule_mutual_rating/create_invitation/schedule_mutual_rating_dashboard_screen.dart';
import 'package:chkm8_app/screens/share_safety_rating/create_invitation/share_safety_rating_screen.dart';
import 'package:chkm8_app/utils/constant.dart';
import 'package:chkm8_app/widgets/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';

class DashboardScreen extends StatelessWidget {
  static final routeName = '/DashboardScreen';

  const DashboardScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg_home.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: <Widget>[
          CustomNavigationBar(
            navTitle: 'Home',
            isShowBack: false,
          ),
          Container(
            margin: EdgeInsets.only(
              top: CustomNavigationBar.heightNavBar +
                  context.media.viewPadding.top,
              left: 20,
              right: 20,
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              physics: BouncingScrollPhysics(
                parent: ClampingScrollPhysics(),
              ),
              children: <Widget>[
                SizedBox(
                  height: (context.isSmallDevice ? 16 : 34),
                ),
                _buildBlock(
                  context,
                  'assets/images/ic_home_share.png',
                  'Share Safety Rating',
                  'Just met? Make sure you\'re both safe for a hang-out.',
                  ColorExt.colorWithHex(0x219653),
                  Constaint.mainColor,
                  () {
                    context.navigator
                        .pushNamed(ShareSafetyRatingScreen.routeName);
                  },
                ),
                SizedBox(height: 20),
                _buildBlock(
                  context,
                  'assets/images/ic_home_calendar.png',
                  'Schedule New Rating',
                  'Going on a date? Invite the other person to set up a mutual safety rating.',
                  ColorExt.colorWithHex(0x2D9CDB),
                  Constaint.scheduleRatingColor,
                  () {
                    context.navigator.pushNamed(
                        ScheduleMutualRatingDashboardScreen.routeName);
                  },
                ),
                SizedBox(height: 20),
                _buildBlock(
                  context,
                  'assets/images/ic_home_rate.png',
                  'Rate Your Date',
                  'How was your date? Give a rating to record your experience.',
                  ColorExt.colorWithHex(0xF2994A),
                  Constaint.rateYourDateColor,
                  () {
                    context.navigator.pushNamed(RateDashboardScreen.routeName);
                  },
                ),
                SizedBox(
                  height: (context.isSmallDevice ? 16 : 34),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlock(
    BuildContext context,
    String icon,
    String title,
    String description,
    Color titleColor,
    Color splashColor,
    Function onTap,
  ) {
    return Container(
      constraints: BoxConstraints(minHeight: 118),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        shadowColor: Colors.blueAccent.withPercentAlpha(0.5),
        margin: EdgeInsets.zero,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onTap,
          highlightColor: splashColor.withPercentAlpha(0.2),
          splashColor: splashColor.withPercentAlpha(0.3),
          child: Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 50,
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    icon,
                    width: 50,
                    height: 50,
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 7),
                      Text(
                        title,
                        style: context.theme.textTheme.headline5.copyWith(
                          fontSize: context.isSmallDevice ? 19 : 20,
                          fontWeight: FontWeight.bold,
                          color: titleColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          description,
                          style: context.theme.textTheme.headline5.copyWith(
                            fontSize: context.isSmallDevice ? 14 : 15,
                            color: ColorExt.colorWithHex(0x4F4F4F),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}