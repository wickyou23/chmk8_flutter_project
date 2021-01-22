import 'dart:math';

import 'package:chkm8_app/bloc/schedule_mutual/schedule_mutual_bloc.dart';
import 'package:chkm8_app/bloc/schedule_mutual/schedule_mutual_state.dart';
import 'package:chkm8_app/models/schedule_mutual_object.dart';
import 'package:chkm8_app/screens/schedule_mutual_rating/accept_invitation/schedule_accept_invitation_code_screen.dart';
import 'package:chkm8_app/screens/schedule_mutual_rating/create_invitation/schedule_rating_selection_screen.dart';
import 'package:chkm8_app/utils/constant.dart';
import 'package:chkm8_app/widgets/app_scaffold.dart';
import 'package:chkm8_app/widgets/custom_button_widget.dart';
import 'package:chkm8_app/widgets/custom_navigation_bar.dart';
import 'package:chkm8_app/widgets/helping_popup_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScheduleMutualRatingDashboardScreen extends StatelessWidget {
  static final routeName = '/ScheduleMutualRatingDashboardScreen';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          CustomNavigationBar(
            navTitle: 'Schedule Mutual Rating',
            navTitleColor: Constaint.scheduleRatingColor,
          ),
          Container(
            margin: EdgeInsets.only(
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
                  'Set up a Mutual Rating for your next date so you can both reflect on the experience.',
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
                  btnColor: Constaint.scheduleRatingColor,
                  onPressed: () {
                    context.navigator
                        .pushNamed(ScheduleRatingSelectionScreen.routeName);
                  },
                ),
                SizedBox(height: 8),
                Container(
                  width: 264,
                  child: Text(
                    'Create an invitation to schedule a Mutual Rating for your upcoming date.',
                    textAlign: TextAlign.center,
                    style: context.theme.textTheme.headline5.copyWith(
                      fontSize: 13,
                      color: ColorExt.colorWithHex(0x4F4F4F),
                    ),
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
                  btnColor: Constaint.scheduleRatingColor,
                  onPressed: () {
                    context.navigator.push(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider<ScheduleMutualBloc>(
                          create: (_) => ScheduleMutualBloc(
                            ScheduleMutualInitializeState(
                              scheduleObj: ScheduleMutualObject(),
                            ),
                          ),
                          child: ScheduleAcceptInvitationScreen(),
                        ),
                        settings: RouteSettings(
                          name: ScheduleAcceptInvitationScreen.routeName,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 8),
                Container(
                  width: 264,
                  child: Text(
                    'Accept invitation to schedule a Mutual Rating for your upcoming date.',
                    textAlign: TextAlign.center,
                    style: context.theme.textTheme.headline5.copyWith(
                      fontSize: 13,
                      color: ColorExt.colorWithHex(0x4F4F4F),
                    ),
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
                          'Now that you\'ve agreed to meet, this provides a way for you to rate the experience afterwards.',
                        ],
                        btnColor: Constaint.scheduleRatingColor,
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: max(context.media.viewPadding.bottom, 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
