import 'dart:math';
import 'dart:ui';
import 'package:chkm8_app/bloc/shared_safety/shared_safety_bloc.dart';
import 'package:chkm8_app/bloc/shared_safety/shared_safety_event.dart';
import 'package:chkm8_app/bloc/shared_safety/shared_safety_state.dart';
import 'package:chkm8_app/frameworks/pin_code_fields/pin_code_fields.dart';
import 'package:chkm8_app/screens/share_safety_rating/create_invitation/invitation_code_countdown_screen.dart';
import 'package:chkm8_app/utils/constant.dart';
import 'package:chkm8_app/widgets/app_scaffold.dart';
import 'package:chkm8_app/widgets/custom_button_widget.dart';
import 'package:chkm8_app/widgets/custom_navigation_bar.dart';
import 'package:chkm8_app/widgets/helping_popup_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateInvitationCodeScreen extends StatefulWidget {
  static final routeName = '/CreateInvitationCodeScreen';

  @override
  _CreateInvitationCodeScreenState createState() =>
      _CreateInvitationCodeScreenState();
}

class _CreateInvitationCodeScreenState
    extends State<CreateInvitationCodeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _textEditingNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      scKey: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<SharedSafetyBloc, SharedSafetyState>(
        listener: (_, state) {
          if (state is SharedSafetyGetMyCodeSuccessState) {
            context.navigator.pushReplacementNamed(
              InvitationCodeCountDownScreen.routeName,
              arguments: state.sharedSafetyCode,
            );
          } else if (state is SharedSafetyGetMyCodeFailedState) {
            _scaffoldKey.currentState
                .showCSSnackBar(state.failedState.errorMessage);
          }
        },
        builder: (_, state) {
          return IgnorePointer(
            ignoring: state is SharedSafetyProcessingState,
            child: Stack(
              children: <Widget>[
                CustomNavigationBar(
                  navTitle: 'Share Safety Rating',
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
                      IgnorePointer(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ((context.media.size.width - 220) / 2),
                          ),
                          child: PinCodeTextField(
                            length: 6,
                            obsecureText: false,
                            animationType: AnimationType.fade,
                            textInputType: TextInputType.number,
                            focusNode: _textEditingNode,
                            controller: _textEditingController,
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
                      SizedBox(height: 37),
                      if (state is SharedSafetyProcessingState)
                        Container(
                          width: 45,
                          height: 45,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            strokeWidth: 3.0,
                          ),
                        ),
                      if (!(state is SharedSafetyProcessingState))
                        CustomButtonWidget(
                          title: 'Create Invitation',
                          width: 257,
                          onPressed: () {
                            context.focus.unfocus();
                            context
                                .bloc<SharedSafetyBloc>()
                                .add(SharedSafetyGetMyCodeEvent());
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
                                'ChkM8 will create & send you a unique code to share with your date',
                              ],
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
        },
      ),
    );
  }
}
