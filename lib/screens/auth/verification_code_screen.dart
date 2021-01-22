import 'dart:async';
import 'package:chkm8_app/bloc/auth/auth_bloc.dart';
import 'package:chkm8_app/bloc/auth/auth_event.dart';
import 'package:chkm8_app/bloc/auth/auth_state.dart';
import 'package:chkm8_app/enum/network_error_enum.dart';
import 'package:chkm8_app/frameworks/pin_code_fields/pin_code_fields.dart';
import 'package:chkm8_app/models/auth_user.dart';
import 'package:chkm8_app/screens/auth/selection_gender_screen.dart';
import 'package:chkm8_app/screens/auth/verification_code_success_screen.dart';
import 'package:chkm8_app/utils/constant.dart';
import 'package:chkm8_app/widgets/app_scaffold.dart';
import 'package:chkm8_app/widgets/custom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum VerificationCodeType {
  signUp,
  changePhone,
}

class VerificationCodeScreen extends StatefulWidget {
  static final routeName = '/VerificationCodeScreen';
  final VerificationCodeType type;

  VerificationCodeScreen({this.type = VerificationCodeType.signUp});

  @override
  _VerificationCodeScreenState createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final StreamController<ErrorAnimationType> _errorController =
      StreamController<ErrorAnimationType>();
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _textEditingNode = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _hasError = false;
  bool _isSignup = true;
  bool _isForceDismissKeyboard = false;
  AuthUser _user;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _errorController.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      scKey: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          context.focus.unfocus();
          _isForceDismissKeyboard = true;
        },
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (ctx, state) {
            if (state is AuthReadyState) {
              var crUser = state.crUser;
              if (crUser.gender != null) {
                context.navigator.pushNamedAndRemoveUntil(
                  VerificationCodeSuccessScreen.routeName,
                  (route) => false,
                );
              } else {
                context.navigator.pushReplacementNamed(
                  SelectionGenderScreen.routeName,
                );
              }
            } else if (state is AuthVerifyCodeFailedState) {
              if (state.failedState.apiError ==
                  NWErrorEnum.phoneOTPFailedError) {
                _hasError = true;
              } else {
                _textEditingController.text = '';
                _scaffoldKey.currentState
                    .showCSSnackBar('Something wrong. Please try again.');
              }
            } else if (state is AuthSigninFailedState ||
                state is AuthSignupFailedState) {
              _scaffoldKey.currentState
                  .showCSSnackBar('Resend code failed. Please try again.');
            }
          },
          builder: (ctx, state) {
            if (state is AuthSigninSuccessState) {
              _user = state.crUser;
              _isSignup = false;
              if (!context.focus.isFirstFocus && !_isForceDismissKeyboard) {
                context.focus.requestFocus(_textEditingNode);
              }
            } else if (state is AuthSignupSuccessState) {
              _user = state.crUser;
              _isSignup = true;
              if (!context.focus.isFirstFocus && !_isForceDismissKeyboard) {
                context.focus.requestFocus(_textEditingNode);
              }
            }

            return Stack(
              children: <Widget>[
                CustomNavigationBar(
                  navTitle: 'Verification',
                ),
                IgnorePointer(
                  ignoring: state is AuthProcessingState,
                  child: Container(
                    color: Colors.transparent,
                    margin: EdgeInsets.only(
                      top: CustomNavigationBar.heightNavBar +
                          context.media.viewPadding.top,
                      left: 20,
                      right: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(height: 60),
                        Text(
                          'A message with your code has been sent to: ${_user.verifyCodePhoneDisplay}. Please enter it here to verify your account:',
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
                            errorAnimationController: _errorController,
                            controller: _textEditingController,
                            textStyle:
                                context.theme.textTheme.headline5.copyWith(
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
                                  : Constaint.mainColor,
                              selectedColor: Constaint.mainColor,
                              selectedFillColor: Colors.white,
                              activeFillColor: Colors.white,
                            ),
                            animationDuration: Duration(milliseconds: 300),
                            backgroundColor: Colors.transparent,
                            enableActiveFill: true,
                            autoFocus: true,
                            onCompleted: (v) {
                              if (_textEditingController.text.length != 6) {
                                setState(() {
                                  _hasError = true;
                                });
                              } else {
                                context.bloc<AuthBloc>().add(
                                      AuthVerifyCodeEvent(
                                        phone: _user.phone,
                                        countryCode: _user.countryCode,
                                        otpCode: _textEditingController.text,
                                      ),
                                    );
                              }
                            },
                            onChanged: (value) {},
                            onTapFocus: () {
                              if (_hasError) {
                                _textEditingController.text = '';
                                _hasError = false;
                                setState(() {});
                              }
                            },
                          ),
                        ),
                        if (_hasError)
                          Text(
                            'The code you entered did not match with the verification code sent to the phone number you entered. Please try again.',
                            textAlign: TextAlign.left,
                            style: context.theme.textTheme.headline5.copyWith(
                              fontSize: 16,
                              color: ColorExt.colorWithHex(0xEB5757),
                            ),
                          ),
                        if (state is AuthProcessingState) SizedBox(height: 50),
                        if (state is AuthProcessingState)
                          Container(
                            width: 45,
                            height: 45,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              strokeWidth: 3.0,
                            ),
                          ),
                        SizedBox(height: 50),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Haven\'t received the code? ',
                            style: context.theme.textTheme.headline5.copyWith(
                              fontSize: 16,
                              color: ColorExt.colorWithHex(0x333333),
                            ),
                            children: [
                              WidgetSpan(
                                child: CupertinoButton(
                                  minSize: 16,
                                  padding: EdgeInsets.zero,
                                  child: Text(
                                    'Resend',
                                    style: context.theme.textTheme.headline5
                                        .copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Constaint.mainColor,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  onPressed: () {
                                    _isForceDismissKeyboard = false;
                                    context.focus.unfocus();
                                    if (_isSignup) {
                                      context.bloc<AuthBloc>().add(
                                            AuthSignupEvent(
                                              phone: _user.phone,
                                              countryCode: _user.countryCode,
                                            ),
                                          );
                                    } else {
                                      context.bloc<AuthBloc>().add(
                                            AuthSigninEvent(
                                              phone: _user.phone,
                                              countryCode: _user.countryCode,
                                            ),
                                          );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
