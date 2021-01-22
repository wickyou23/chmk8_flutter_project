import 'package:chkm8_app/bloc/shared_safety/shared_safety_bloc.dart';
import 'package:chkm8_app/bloc/shared_safety/shared_safety_state.dart';
import 'package:chkm8_app/screens/share_safety_rating/safety_rating_report_screen.dart';
import 'package:chkm8_app/utils/constant.dart';
import 'package:chkm8_app/widgets/app_scaffold.dart';
import 'package:chkm8_app/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AcceptInvitationSuccessScreen extends StatelessWidget {
  static final routeName = '/AcceptInvitationSuccessScreen';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AppScaffold(
        body: BlocBuilder<SharedSafetyBloc, SharedSafetyState>(
          builder: (ctx, state) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 37),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 167,
                      child: AspectRatio(
                        aspectRatio: 500 / 473,
                        child: Image.asset(
                          'assets/images/bg_accept_invitation_success_screen.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 75),
                    Text(
                      'You have successfully accepted the invitation to mutually share and view Safety Ratings. Tap "View Safety Rating" for details.',
                      textAlign: TextAlign.center,
                      style: context.theme.textTheme.headline5.copyWith(
                        fontSize: 18,
                        color: Constaint.defaultTextColor,
                      ),
                    ),
                    SizedBox(height: 75),
                    CustomButtonWidget(
                      title: 'View Safety Rating',
                      width: context.media.size.width - 92,
                      btnColor: Constaint.mainColor,
                      onPressed: () {
                        context.navigator.pushReplacement(
                          MaterialPageRoute(
                            builder: (ctx) => BlocProvider<SharedSafetyBloc>(
                              create: (_) => SharedSafetyBloc(state),
                              child: SafetyRatingReportScreen(),
                            ),
                            settings: RouteSettings(
                              name: SafetyRatingReportScreen.routeName,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
