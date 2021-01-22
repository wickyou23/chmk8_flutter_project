import 'package:chkm8_app/bloc/schedule_mutual/schedule_mutual_bloc.dart';
import 'package:chkm8_app/bloc/schedule_mutual/schedule_mutual_event.dart';
import 'package:chkm8_app/bloc/schedule_mutual/schedule_mutual_state.dart';
import 'package:chkm8_app/frameworks/pin_code_fields/pin_code_fields.dart';
import 'package:chkm8_app/models/schedule_mutual_object.dart';
import 'package:chkm8_app/screens/schedule_mutual_rating/create_invitation/schedule_invitation_code_countdown_screen.dart';
import 'package:chkm8_app/utils/constant.dart';
import 'package:chkm8_app/utils/extension.dart';
import 'package:chkm8_app/widgets/app_scaffold.dart';
import 'package:chkm8_app/widgets/custom_button_widget.dart';
import 'package:chkm8_app/widgets/custom_navigation_bar.dart';
import 'package:chkm8_app/widgets/helping_popup_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScheduleCreateInvitationCodeScreen extends StatefulWidget {
  static final routeName = '/ScheduleCreateInvitationCodeScreen';

  @override
  _ScheduleCreateInvitationCodeScreenState createState() =>
      _ScheduleCreateInvitationCodeScreenState();
}

class _ScheduleCreateInvitationCodeScreenState
    extends State<ScheduleCreateInvitationCodeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  ScheduleMutualObject _scheduleObj;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      scKey: _scaffoldState,
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<ScheduleMutualBloc, ScheduleMutualState>(
        listener: (ctx, state) {
          if (state is ScheduleMutualGetSharedCodeSuccessState) {
            context.navigator.pushReplacement(
              MaterialPageRoute(
                builder: (ctx) => BlocProvider<ScheduleMutualBloc>(
                  create: (_) => ScheduleMutualBloc(
                    ScheduleMutualGetSharedCodeSuccessState(
                      scheduleObj: state.scheduleObj,
                    ),
                  ),
                  child: ScheduleInvitationCodeCountDownScreen(),
                ),
                settings: RouteSettings(
                  name: ScheduleInvitationCodeCountDownScreen.routeName,
                ),
              ),
            );
          } else if (state is ScheduleMutualGetSharedCodeFailedState) {
            if (state.failedState.statusCode == 101) {
              _scaffoldState.currentState
                  .showCSSnackBar(state.failedState.errorMessage);
            } else {
              _scaffoldState.currentState.showCSSnackBar(
                'Get shared code failed!. Please try again.',
              );
            }
          }
        },
        builder: (ctx, state) {
          if (state is ScheduleMutualInitializeState) {
            _scheduleObj = state.scheduleObj;
          }

          return Stack(
            children: <Widget>[
              CustomNavigationBar(
                navTitle: 'Schedule Mutual Rating',
                navTitleColor: Constaint.scheduleRatingColor,
              ),
              Container(
                padding: EdgeInsets.only(
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
                      'Create an invitation code',
                      textAlign: TextAlign.center,
                      style: context.theme.textTheme.headline5.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ColorExt.colorWithHex(0x4F4F4F),
                      ),
                    ),
                    SizedBox(height: 46),
                    Form(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ((context.media.size.width - 220) / 2),
                        ),
                        child: IgnorePointer(
                          child: PinCodeTextField(
                            length: 6,
                            obsecureText: false,
                            animationType: AnimationType.fade,
                            textInputType: TextInputType.number,
                            textStyle: TextStyle(
                              fontFamily: 'Moderat',
                              fontSize: 40,
                            ),
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.underline,
                              fieldHeight: 53,
                              fieldWidth: 24,
                              inactiveColor: Constaint.defaultTextColor,
                              inactiveFillColor: Colors.transparent,
                              activeColor: Colors.transparent,
                              activeFillColor: Colors.transparent,
                              selectedColor: Constaint.defaultTextColor,
                              selectedFillColor: Colors.transparent,
                            ),
                            animationDuration: Duration(milliseconds: 300),
                            backgroundColor: Colors.transparent,
                            enableActiveFill: true,
                            onChanged: (value) {},
                            onTapFocus: null,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 37),
                    if (state is ScheduleMutualProcessingState)
                      Container(
                        width: 45,
                        height: 45,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          strokeWidth: 3.0,
                        ),
                      ),
                    if (!(state is ScheduleMutualProcessingState))
                      CustomButtonWidget(
                        title: 'Create Invitation',
                        width: 257,
                        btnColor: Constaint.scheduleRatingColor,
                        onPressed: () {
                          context.focus.unfocus();
                          context.bloc<ScheduleMutualBloc>().add(
                                ScheduleMutualGetSharedCodeEvent(
                                  scheduleObj: _scheduleObj,
                                ),
                              );
                        },
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
                              'Once this code is accepted, you\'ll be ready to Rate your Date',
                            ],
                            btnColor: Constaint.scheduleRatingColor,
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: (context.media.viewPadding.bottom == 0
                          ? 10
                          : context.media.viewPadding.bottom),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
