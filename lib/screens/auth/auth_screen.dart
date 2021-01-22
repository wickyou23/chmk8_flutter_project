import 'dart:math';
import 'package:chkm8_app/bloc/auth/auth_bloc.dart';
import 'package:chkm8_app/bloc/auth/auth_event.dart';
import 'package:chkm8_app/bloc/auth/auth_state.dart';
import 'package:chkm8_app/enum/network_error_enum.dart';
import 'package:chkm8_app/screens/auth/verification_code_screen.dart';
import 'package:chkm8_app/screens/privacy/policy_privacy_screen.dart';
import 'package:chkm8_app/screens/privacy/terms_of_service_screen.dart';
import 'package:chkm8_app/utils/constant.dart';
import 'package:chkm8_app/utils/utils.dart';
import 'package:chkm8_app/widgets/app_scaffold.dart';
import 'package:chkm8_app/widgets/custom_button_widget.dart';
import 'package:chkm8_app/widgets/custom_textformfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';


class AuthScreen extends StatefulWidget {
  static final routeName = '/AuthScreen';
  final bool isShowSignupFirst;
  final bool authLogout;

  AuthScreen({
    this.isShowSignupFirst = true,
    this.authLogout = false,
  });

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  GlobalKey<FormState> _signinForm = GlobalKey<FormState>();
  GlobalKey<FormState> _signupForm = GlobalKey<FormState>();
  TextEditingController _signinEditingController = TextEditingController();
  TextEditingController _signupEditingController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  double _heightTopImage = 0;
  bool _isSignUp = true;
  bool _isKeepLogin = true;
  bool _isAcceptPolicy = false;
  bool _isPhoneInvalid = false;
  bool _isAuthLogout = false;
  PhoneNumber _formatPhoneNumber;
  NWErrorEnum _apiError;
  String get _phoneInput {
    String phone = _isSignUp
        ? _signupEditingController.text
        : _signinEditingController.text;
    if (!phone.startsWith('+')) {
      phone = '+$phone';
    }

    return phone.trim();
  }

  @override
  void initState() {
    _isAuthLogout = this.widget.authLogout;
    _isSignUp = this.widget.isShowSignupFirst;
    _tryGetMyCountryCode();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_isAuthLogout) {
        _isAuthLogout = false;
        Future.delayed(Duration(milliseconds: 500), () {
          context.showAlert(message: 'Account logged into another device.');
        });
      }
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _heightTopImage = context.media.size.width * 0.5324074074074074;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _signinEditingController.dispose();
    _signupEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      scKey: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: context.media.size.height),
            child: IntrinsicHeight(
              child: Stack(
                children: <Widget>[
                  Image.asset(
                    'assets/images/bg_top_auth.png',
                    width: context.media.size.width,
                    height: _heightTopImage,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: _heightTopImage + (context.isSmallDevice ? 0 : 20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: (_isSignUp) ? _signUpWidget() : _signInWidget(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignIn() async {
    FocusScope.of(context).unfocus();
    this.resetPhoneNumer();
    if (!_signinForm.currentState.validate()) {
      return;
    }

    try {
      _formatPhoneNumber = await PhoneNumber.getRegionInfoFromPhoneNumber(
        _phoneInput,
      );
      context.bloc<AuthBloc>().add(
            AuthSigninEvent(
              phone: _phoneInput,
              countryCode: _formatPhoneNumber.isoCode,
            ),
          );
    } catch (e) {
      _isPhoneInvalid = true;
      _signinForm.currentState.validate();
    }
  }

  Future<void> _handleSignUp() async {
    FocusScope.of(context).unfocus();
    this.resetPhoneNumer();
    if (!_signupForm.currentState.validate()) {
      return;
    }

    try {
      _formatPhoneNumber = await PhoneNumber.getRegionInfoFromPhoneNumber(
        _phoneInput,
      );
      context.bloc<AuthBloc>().add(
            AuthSignupEvent(
              phone: _phoneInput,
              countryCode: _formatPhoneNumber.isoCode,
            ),
          );
    } catch (e) {
      _isPhoneInvalid = true;
      _signupForm.currentState.validate();
    }
  }

  String _validatorPhoneNumber() {
    if (_phoneInput.isEmpty) {
      return 'Phone number is required';
    }

    final validPhone = _phoneInput.validatorPhoneNumber;
    if (!validPhone) {
      return 'Wrong mobile format number';
    }

    if (_isPhoneInvalid) {
      return 'Wrong mobile format number';
    }

    if (_apiError == NWErrorEnum.phoneExistsError) {
      return 'The phone number already exists. Please log in.';
    } else if (_apiError == NWErrorEnum.phoneNotExistsError) {
      return 'The phone number not found. Please sign up.';
    } else if (_apiError == NWErrorEnum.phoneInvalidError) {
      return 'Wrong mobile format number';
    }

    return null;
  }

  void resetPhoneNumer() {
    _formatPhoneNumber = null;
    _apiError = null;
    _isPhoneInvalid = false;
  }

  Widget _signUpWidget() {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (ctx, state) {
        if (!context.route.isCurrent) {
          return;
        }

        if (state is AuthSignupSuccessState) {
          context.navigator.pushNamed(VerificationCodeScreen.routeName);
        } else if (state is AuthSignupFailedState) {
          _apiError = state.failedState.apiError;
          if (_apiError != null) {
            _signupForm.currentState.validate();
          } else {
            _scaffoldKey.currentState
                .showCSSnackBar(state.failedState.errorMessage);
          }
        }
      },
      builder: (ctx, state) {
        return IgnorePointer(
          ignoring: state is AuthProcessingState,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Sign up',
                style: context.theme.textTheme.headline5.copyWith(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Constaint.mainColor,
                ),
              ),
              SizedBox(height: 25),
              Form(
                key: _signupForm,
                child: CustomTextFormField(
                  controller: _signupEditingController,
                  title: 'Enter cell phone number',
                  keyboardType: TextInputType.phone,
                  placeHolder: 'e.g. +12025550175',
                  onChanged: (_) {
                    this.resetPhoneNumer();
                  },
                  onValidator: (text) {
                    return _validatorPhoneNumber();
                  },
                ),
              ),
              SizedBox(height: 10),
              Text(
                'A verification code will be sent to this phone number via text, so make sure you have your phone handy.',
                style: context.theme.textTheme.headline5.copyWith(
                  fontSize: 13,
                  color: ColorExt.colorWithHex(0x4F4F4F),
                ),
              ),
              SizedBox(
                height: (context.isSmallDevice ? 30 : 46),
              ),
              Row(
                children: <Widget>[
                  ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    child: SizedBox(
                      width: Checkbox.width,
                      height: Checkbox.width,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Checkbox(
                          value: _isAcceptPolicy,
                          onChanged: (state) {
                            setState(() {
                              _isAcceptPolicy = state;
                            });
                          },
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Flexible(
                    child: RichText(
                      text: TextSpan(
                        text: 'Agree to ',
                        style: context.theme.textTheme.headline5.copyWith(
                          fontSize: 13,
                          color: ColorExt.colorWithHex(0x333333),
                        ),
                        children: [
                          WidgetSpan(
                            child: CupertinoButton(
                              minSize: 16,
                              padding: EdgeInsets.zero,
                              child: Text(
                                'Terms of Service',
                                style:
                                    context.theme.textTheme.headline5.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Constaint.mainColor,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              onPressed: () {
                                context.navigator
                                    .pushNamed(TermsOfServiceScreen.routeName);
                              },
                            ),
                          ),
                          TextSpan(
                            text: ' and ',
                            style: context.theme.textTheme.headline5.copyWith(
                              fontSize: 13,
                              color: ColorExt.colorWithHex(0x333333),
                            ),
                          ),
                          WidgetSpan(
                            child: CupertinoButton(
                              minSize: 16,
                              padding: EdgeInsets.zero,
                              child: Text(
                                'Privacy Policy',
                                style:
                                    context.theme.textTheme.headline5.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Constaint.mainColor,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              onPressed: () {
                                context.navigator
                                    .pushNamed(PolicyPrivacyScreen.routeName);
                              },
                            ),
                          ),
                          TextSpan(
                            text: '.',
                            style: context.theme.textTheme.headline5.copyWith(
                              fontSize: 13,
                              color: ColorExt.colorWithHex(0x333333),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              if (state is AuthProcessingState)
                Container(
                  width: 45,
                  height: 45,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    strokeWidth: 3.0,
                  ),
                ),
              if (!(state is AuthProcessingState))
                Container(
                  alignment: Alignment.center,
                  child: CustomButtonWidget(
                    title: 'Sign up',
                    onPressed: _isAcceptPolicy
                        ? () {
                            _handleSignUp();
                          }
                        : null,
                  ),
                ),
              Expanded(child: Container()),
              Text(
                'or',
                textAlign: TextAlign.center,
                style: context.theme.textTheme.headline5.copyWith(
                  fontSize: 16,
                  color: ColorExt.colorWithHex(0x333333),
                ),
              ),
              CupertinoButton(
                child: Text(
                  'Log in',
                  style: context.theme.textTheme.headline5.copyWith(
                    fontSize: 16,
                    color: Constaint.mainColor,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _isSignUp = !_isSignUp;
                    _signinEditingController.text =
                        _signupEditingController.text;
                    this.resetPhoneNumer();
                  });
                },
              ),
              SizedBox(height: max(context.media.viewPadding.bottom, 16)),
            ],
          ),
        );
      },
    );
  }

  Widget _signInWidget() {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (ctx, state) {
        if (!context.route.isCurrent) {
          return;
        }

        if (state is AuthSigninSuccessState) {
          context.navigator.pushNamed(VerificationCodeScreen.routeName);
        } else if (state is AuthSigninFailedState) {
          _apiError = state.failedState.apiError;
          if (_apiError != null) {
            _signinForm.currentState.validate();
          } else {
            _scaffoldKey.currentState
                .showCSSnackBar(state.failedState.errorMessage);
          }
        }
      },
      builder: (ctx, state) {
        return IgnorePointer(
          ignoring: state is AuthProcessingState,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Log in',
                style: context.theme.textTheme.headline5.copyWith(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Constaint.mainColor,
                ),
              ),
              SizedBox(height: 43),
              Form(
                key: _signinForm,
                autovalidate: false,
                child: CustomTextFormField(
                  controller: _signinEditingController,
                  title: 'Phone Number',
                  keyboardType: TextInputType.phone,
                  placeHolder: 'e.g. +12025550175',
                  onChanged: (_) {
                    this.resetPhoneNumer();
                  },
                  onValidator: (text) {
                    return _validatorPhoneNumber();
                  },
                ),
              ),
              SizedBox(height: 22),
              Row(
                children: <Widget>[
                  ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    child: SizedBox(
                      width: Checkbox.width,
                      height: Checkbox.width,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Checkbox(
                          value: _isKeepLogin,
                          onChanged: (state) {
                            setState(() {
                              _isKeepLogin = state;
                            });
                          },
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Keep me logged in.',
                      style: context.theme.textTheme.headline5.copyWith(
                        fontSize: 16,
                        color: ColorExt.colorWithHex(0x333333),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 49),
              if (state is AuthProcessingState)
                Container(
                  width: 45,
                  height: 45,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    strokeWidth: 3.0,
                  ),
                ),
              if (!(state is AuthProcessingState))
                Container(
                  alignment: Alignment.center,
                  child: CustomButtonWidget(
                    title: 'Log in',
                    onPressed: () {
                      _handleSignIn();
                    },
                  ),
                ),
              Expanded(child: Container()),
              Text(
                'or',
                textAlign: TextAlign.center,
                style: context.theme.textTheme.headline5.copyWith(
                  fontSize: 16,
                  color: ColorExt.colorWithHex(0x333333),
                ),
              ),
              CupertinoButton(
                child: Text(
                  'Sign up',
                  style: context.theme.textTheme.headline5.copyWith(
                    fontSize: 16,
                    color: Constaint.mainColor,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _isSignUp = !_isSignUp;
                    _signupEditingController.text =
                        _signinEditingController.text;
                    this.resetPhoneNumer();
                  });
                },
              ),
              SizedBox(height: max(context.media.viewPadding.bottom, 16)),
            ],
          ),
        );
      },
    );
  }

  Future<void> _tryGetMyCountryCode() async {
    String dialCode = await Utils.getMyDialCodeByIp();
    if (dialCode.isEmpty) return;

    if (_signupEditingController.text.isEmpty) {
      _signupEditingController.text = dialCode;
    }

    if (_signinEditingController.text.isEmpty) {
      _signinEditingController.text = dialCode;
    }
  }
}
