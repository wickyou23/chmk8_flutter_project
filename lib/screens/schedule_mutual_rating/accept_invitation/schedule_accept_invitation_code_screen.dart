import 'package:chkm8_app/bloc/schedule_mutual/schedule_mutual_bloc.dart';
import 'package:chkm8_app/bloc/schedule_mutual/schedule_mutual_event.dart';
import 'package:chkm8_app/bloc/schedule_mutual/schedule_mutual_state.dart';
import 'package:chkm8_app/enum/network_error_enum.dart';
import 'package:chkm8_app/frameworks/pin_code_fields/pin_code_fields.dart';
import 'package:chkm8_app/screens/home_screen.dart';
import 'package:chkm8_app/screens/schedule_mutual_rating/schedule_pick_date_rating_screen.dart';
import 'package:chkm8_app/utils/constant.dart';
import 'package:chkm8_app/utils/utils.dart';
import 'package:chkm8_app/widgets/app_scaffold.dart';
import 'package:chkm8_app/widgets/custom_button_widget.dart';
import 'package:chkm8_app/widgets/custom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScheduleAcceptInvitationScreen extends StatefulWidget {
  static final routeName = '/ScheduleAcceptInvitationScreen';

  @override
  _ScheduleAcceptInvitationScreen createState() =>
      _ScheduleAcceptInvitationScreen();
}

class _ScheduleAcceptInvitationScreen
    extends State<ScheduleAcceptInvitationScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _textEditingNode = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  bool _invitationCodeValid = false;
  bool _hasError = false;
  NWErrorEnum _desErrorEnum;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      scKey: _scaffoldState,
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<ScheduleMutualBloc, ScheduleMutualState>(
        listener: (ctx, state) {
          if (state is ScheduleMutualAcceptSharedCodeSuccessState) {
            context.navigator.pushReplacement(
              MaterialPageRoute(
                builder: (_) => BlocProvider<ScheduleMutualBloc>(
                  create: (_) => ScheduleMutualBloc(
                    ScheduleMutualInitializeState(
                      scheduleObj: state.scheduleObj,
                    ),
                  ),
                  child: SchedulePickDateRatingScreen(),
                ),
                settings: RouteSettings(
                  name: SchedulePickDateRatingScreen.routeName,
                ),
              ),
            );
          } else if (state is ScheduleMutualAcceptSharedCodeFailedState) {
            _invitationCodeValid = false;
            if (state.failedState.apiError == NWErrorEnum.sharedCodeInvalid) {
              _hasError = true;
            } else {
              _textEditingController.text = '';
              _scaffoldState.currentState.showCSSnackBar(
                  'Accept shared code failed. Please try again.');
            }
          } else if (state is ScheduleMutualValidateSharedCodeSuccessState) {
            _invitationCodeValid = true;
          } else if (state is ScheduleMutualValidateSharedCodeFailedState) {
            if (state.failedState.apiError == NWErrorEnum.sharedCodeInvalid ||
                state.failedState.apiError == NWErrorEnum.sharedCodeExpired) {
              _desErrorEnum = state.failedState.apiError;
              _hasError = true;
            } else {
              _textEditingController.text = '';
              _scaffoldState.currentState
                  .showCSSnackBar(state.failedState.errorMessage);
            }
          }
        },
        builder: (ctx, state) {
          return Stack(
            children: <Widget>[
              CustomNavigationBar(
                navTitle: 'Accept Invitation',
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
                  children: <Widget>[
                    SizedBox(height: 60),
                    Text(
                      'Enter the invitation code you received',
                      textAlign: TextAlign.center,
                      style: context.theme.textTheme.headline5.copyWith(
                        fontSize: 16,
                        color: ColorExt.colorWithHex(0x4F4F4F),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 43),
                    Form(
                      child: PinCodeTextField(
                        length: 6,
                        obsecureText: false,
                        animationType: AnimationType.fade,
                        textInputType: TextInputType.number,
                        focusNode: _textEditingNode,
                        controller: _textEditingController,
                        textStyle: context.theme.textTheme.headline5.copyWith(
                          fontSize: 20,
                          color: ColorExt.colorWithHex(0x4F4F4F),
                        ),
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(9),
                          fieldHeight: 53,
                          fieldWidth: 45,
                          borderWidth: 1,
                          inactiveColor: Colors.transparent,
                          inactiveFillColor: ColorExt.colorWithHex(0xF2F2F2)
                              .withPercentAlpha(0.8),
                          activeColor: (_hasError)
                              ? ColorExt.colorWithHex(0xEB5757)
                              : Constaint.scheduleRatingColor,
                          selectedColor: Constaint.scheduleRatingColor,
                          selectedFillColor: Colors.white,
                          activeFillColor: Colors.white,
                        ),
                        animationDuration: Duration(milliseconds: 300),
                        backgroundColor: Colors.transparent,
                        enableActiveFill: true,
                        autoFocus: true,
                        onCompleted: (v) {
                          if (_textEditingController.text.length != 6) {
                            _invitationCodeValid = false;
                            _hasError = true;
                          } else {
                            context.bloc<ScheduleMutualBloc>().add(
                                  ScheduleMutualValidateSharedCodeEvent(
                                    code: v,
                                  ),
                                );
                          }

                          setState(() {});
                        },
                        onChanged: (value) {},
                        onTapFocus: () {
                          if (_hasError) {
                            _textEditingController.text = '';
                            _hasError = false;
                            _desErrorEnum = null;
                            setState(() {});
                          }
                        },
                      ),
                    ),
                    if (_hasError)
                      Text(
                        _desErrorEnum == null ? '' : _desErrorEnum.errorMessage,
                        style: context.theme.textTheme.headline5.copyWith(
                          fontSize: 16,
                          color: ColorExt.colorWithHex(0xEB5757),
                        ),
                      ),
                    SizedBox(height: 50),
                    if (!_invitationCodeValid &&
                        state is ScheduleMutualProcessingState)
                      Utils.getLoadingWidget(),
                    if (_invitationCodeValid && !_hasError)
                      ..._buildBottomWidget(state)
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildBottomWidget(ScheduleMutualState state) {
    return [
      if (state is ScheduleMutualProcessingState) Utils.getLoadingWidget(),
      if (_invitationCodeValid && !(state is ScheduleMutualProcessingState))
        CustomButtonWidget(
          title: 'Accept Invitation',
          width: 257,
          btnColor: Constaint.scheduleRatingColor,
          onPressed: _invitationCodeValid
              ? () {
                  context.bloc<ScheduleMutualBloc>().add(
                        ScheduleMutualAcceptSharedCodeEvent(
                          code: _textEditingController.text,
                        ),
                      );
                }
              : null,
        ),
      SizedBox(height: 16),
      CupertinoButton(
        child: Text(
          'Cancel',
          style: context.theme.textTheme.headline5.copyWith(
            color: ColorExt.colorWithHex(0x4F4F4F),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          context.navigator.popUntil(
            (route) => route.settings.name == HomeScreen.routeName,
          );
        },
      ),
    ];
  }
}
