import 'dart:async';
import 'dart:math';
import 'package:chkm8_app/bloc/global/global_bloc.dart';
import 'package:chkm8_app/bloc/global/global_event.dart';
import 'package:chkm8_app/bloc/schedule_mutual/schedule_mutual_bloc.dart';
import 'package:chkm8_app/bloc/schedule_mutual/schedule_mutual_event.dart';
import 'package:chkm8_app/bloc/schedule_mutual/schedule_mutual_state.dart';
import 'package:chkm8_app/enum/lastest_accept_enum.dart';
import 'package:chkm8_app/frameworks/circular_countdown_timer/circular_countdown_timer.dart';
import 'package:chkm8_app/models/schedule_mutual_object.dart';
import 'package:chkm8_app/screens/home_screen.dart';
import 'package:chkm8_app/screens/share_safety_rating/create_invitation/invitation_code_countdown_screen.dart';
import 'package:chkm8_app/services/local_store_service.dart';
import 'package:chkm8_app/utils/constant.dart';
import 'package:chkm8_app/utils/utils.dart';
import 'package:chkm8_app/widgets/app_scaffold.dart';
import 'package:chkm8_app/widgets/custom_button_widget.dart';
import 'package:chkm8_app/widgets/custom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScheduleInvitationCodeCountDownScreen extends StatefulWidget {
  static final routeName = '/ScheduleInvitationCodeCountDownScreen';

  @override
  _ScheduleInvitationCodeCountDownScreen createState() =>
      _ScheduleInvitationCodeCountDownScreen();
}

class _ScheduleInvitationCodeCountDownScreen
    extends State<ScheduleInvitationCodeCountDownScreen>
    with InvitationCodeCountDown {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isExpired = false;
  bool _isShowCopyWidget = false;
  String _myCode = '';
  ScheduleMutualObject _scheduleObj;
  Timer _timerShowBanner;
  ValueKey _circleCountDownKey;

  @override
  void dispose() {
    _timerShowBanner?.cancel();
    super.dispose();
  }

  void showBanner() {
    _timerShowBanner?.cancel();
    _isShowCopyWidget = true;
    _timerShowBanner = Timer(Duration(seconds: 3), () {
      _isShowCopyWidget = false;
      setState(() {});
    });
  }

  void closeBanner() {
    _timerShowBanner?.cancel();
    _isShowCopyWidget = false;
    _timerShowBanner = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AppScaffold(
        scKey: _scaffoldKey,
        body: BlocConsumer<ScheduleMutualBloc, ScheduleMutualState>(
          listener: (ctx, state) {},
          builder: (ctx, state) {
            if (state is ScheduleMutualGetSharedCodeSuccessState) {
              _scheduleObj = state.scheduleObj;
              if (_myCode != _scheduleObj.sharedCode) {
                LocalStoreService().scheduleCodeWaiting =
                    _scheduleObj.sharedCode;
              }

              _myCode = _scheduleObj.sharedCode;
              _circleCountDownKey = ValueKey(_myCode);
              if (!_isExpired) {
                this.checkIsCodeCopied(_myCode).then((value) {
                  if (!value) {
                    this.copyCode(_myCode);
                    this.showBanner();
                    setState(() {});
                  }
                });
              }
            } else if (state is ScheduleMutualGetSharedCodeFailedState) {
              _scaffoldKey.currentState
                  .showCSSnackBar(state.failedState.errorMessage);
              _isShowCopyWidget = false;
            }

            return Stack(
              fit: StackFit.expand,
              children: <Widget>[
                CustomNavigationBar(
                  navTitle: 'Schedule Mutual Rating',
                  isShowBack: false,
                  navTitleColor: Constaint.scheduleRatingColor,
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    top: CustomNavigationBar.heightNavBar +
                        context.media.viewPadding.top -
                        10,
                    left: 20,
                    right: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      AnimatedOpacity(
                        key: ValueKey('IsShowCopyWidget'),
                        duration: Duration(milliseconds: 250),
                        opacity: _isShowCopyWidget ? 1 : 0,
                        child: Container(
                          height: 35,
                          width: 310,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: ColorExt.colorWithHex(0x2D9CDB),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Transform.translate(
                            offset: Offset(8, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Invitation code copied and ready to share',
                                  style: context.theme.textTheme.headline5
                                      .copyWith(
                                    fontSize: 13,
                                    color: Colors.white,
                                  ),
                                ),
                                Container(
                                  child: CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    child: ImageIcon(
                                      AssetImage('assets/images/ic_close.png'),
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      this.closeBanner();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: (context.isSmallDevice) ? 16 : 30),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text:
                              'Share the invitation code to schedule a Mutual Rating for ',
                          style: context.theme.textTheme.headline5.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Constaint.defaultTextColor,
                          ),
                          children: [
                            TextSpan(
                              text: '${_scheduleObj.nickName}',
                              style: context.theme.textTheme.headline5.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  decoration: TextDecoration.underline),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: (context.isSmallDevice) ? 16 : 26),
                      Stack(
                        children: [
                          Container(
                            width: context.media.size.width,
                            child: this.generateCodeText(_myCode),
                          ),
                          Positioned(
                            right: (context.media.size.width / 2) -
                                this.generateCodeText(_myCode).textSize.width -
                                16,
                            top: 4,
                            child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              child: Image.asset(
                                'assets/images/ic_schedule_copy.png',
                                width: 43,
                                height: 43,
                              ),
                              onPressed: () async {
                                if (_isExpired) {
                                  _isShowCopyWidget = false;
                                  _scaffoldKey.currentState.showCSSnackBar(
                                      'The code is expired. Please create a new.');
                                } else {
                                  this.copyCode(_myCode);
                                  this.showBanner();
                                }
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: (context.isSmallDevice) ? 10 : 25),
                      CircularCountDownTimer(
                        scKey: _circleCountDownKey,
                        duration: 90,
                        width: 120,
                        height: 120,
                        color: Colors.grey[200],
                        fillColor: Constaint.scheduleRatingColor,
                        strokeWidth: 3.0,
                        textStyle: context.theme.textTheme.headline5.copyWith(
                          fontSize: 40,
                          color: ColorExt.colorWithHex(0xF2994A),
                        ),
                        isReverse: true,
                        onCount: (count) {
                          if (count == 30) {
                            context.bloc<GlobalBloc>().add(
                                  GlobalGetLastestAccpetEvent(
                                    type: LastestAcceptEnum.schedulingRating,
                                  ),
                                );
                          }
                        },
                        onComplete: () async {
                          appPrint('Countdown Ended');
                          _isExpired = true;
                          var isCopied = await this.checkIsCodeCopied(_myCode);
                          if (isCopied) {
                            this.resetCopiedCode(_myCode);
                          }

                          setState(() {});
                        },
                      ),
                      SizedBox(height: (context.isSmallDevice) ? 10 : 30),
                      if (state is ScheduleMutualProcessingState)
                        Utils.getLoadingWidget(),
                      if (!(state is ScheduleMutualProcessingState))
                        CustomButtonWidget(
                          title: 'Create New Invitation',
                          width: context.media.size.width - 70,
                          btnColor: Constaint.scheduleRatingColor,
                          onPressed: _isExpired
                              ? () {
                                  _isExpired = false;
                                  this.resetCopiedCode(_myCode);
                                  _myCode = '';
                                  context.bloc<ScheduleMutualBloc>().add(
                                        ScheduleMutualGetSharedCodeEvent(
                                          scheduleObj: _scheduleObj,
                                        ),
                                      );
                                }
                              : null,
                        ),
                      SizedBox(height: (context.isSmallDevice) ? 10 : 20),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Text(
                          'Cancel Invitation',
                          style: context.theme.textTheme.headline5.copyWith(
                            fontSize: 16,
                            color: Constaint.defaultTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          if (!_isExpired) {
                            context.bloc<ScheduleMutualBloc>().add(
                                  ScheduleMutualCancelSharedCodeEvent(
                                    code: _myCode,
                                  ),
                                );
                          }

                          LocalStoreService().safetyCodeWaiting = null;
                          context.navigator.popUntil(
                            (route) =>
                                route.settings.name == HomeScreen.routeName,
                          );
                        },
                      ),
                      Expanded(child: Container()),
                      Text(
                        'Pro Tip:',
                        style: context.theme.textTheme.headline5.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Constaint.scheduleRatingColor,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Your friend needs the ChkM8 app to accept the invitation',
                        textAlign: TextAlign.center,
                        style: context.theme.textTheme.headline5.copyWith(
                          fontSize: context.isSmallDevice ? 14 : 16,
                          color: ColorExt.colorWithHex(0x333333),
                        ),
                      ),
                      SizedBox(
                        height: max(
                          context.media.viewPadding.bottom,
                          context.isSmallDevice ? 8 : 16,
                        ),
                      ),
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
