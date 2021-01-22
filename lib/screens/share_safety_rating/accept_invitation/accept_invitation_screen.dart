import 'package:chkm8_app/bloc/shared_safety/shared_safety_bloc.dart';
import 'package:chkm8_app/bloc/shared_safety/shared_safety_event.dart';
import 'package:chkm8_app/bloc/shared_safety/shared_safety_state.dart';
import 'package:chkm8_app/enum/network_error_enum.dart';
import 'package:chkm8_app/frameworks/pin_code_fields/pin_code_fields.dart';
import 'package:chkm8_app/models/rating_review_object.dart';
import 'package:chkm8_app/screens/home_screen.dart';
import 'package:chkm8_app/screens/share_safety_rating/accept_invitation/accept_invitation_success_screen.dart';
import 'package:chkm8_app/utils/constant.dart';
import 'package:chkm8_app/widgets/app_scaffold.dart';
import 'package:chkm8_app/widgets/custom_button_widget.dart';
import 'package:chkm8_app/widgets/custom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AcceptInvitationScreen extends StatefulWidget {
  static final routeName = '/AcceptInvitationScreen';

  @override
  _AcceptInvitationScreenState createState() => _AcceptInvitationScreenState();
}

class _AcceptInvitationScreenState extends State<AcceptInvitationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _textEditingNode = FocusNode();
  RatingReviewObject _rating;
  bool _hasError = false;
  NWErrorEnum _desErrorEnum;
  String _currentCode;
  bool _invitationCodeValid = false;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      scKey: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<SharedSafetyBloc, SharedSafetyState>(
        listener: (ctx, state) {
          if (state is SharedSafetyAcceptCodeSuccessState) {
            _rating = state.rating;
            context.navigator.pushReplacement(
              MaterialPageRoute(
                builder: (ctx) => BlocProvider<SharedSafetyBloc>(
                  create: (_) => SharedSafetyBloc(
                    SharedSafetyReviewState(
                      rating: _rating.copyWith(
                        code: _textEditingController.text,
                      ),
                    ),
                  ),
                  child: AcceptInvitationSuccessScreen(),
                ),
                settings: RouteSettings(
                  name: AcceptInvitationSuccessScreen.routeName,
                ),
              ),
            );
          } else if (state is SharedSafetyValidateCodeSuccessState) {
            _invitationCodeValid = true;
          } else if (state is SharedSafetyAcceptCodeFailedState) {
            _invitationCodeValid = false;
            if (state.failedState.apiError == NWErrorEnum.sharedCodeInvalid ||
                state.failedState.apiError == NWErrorEnum.sharedCodeExpired) {
              _desErrorEnum = state.failedState.apiError;
              _hasError = true;
              _rating = null;
            } else {
              _textEditingController.text = '';
              _scaffoldKey.currentState.showCSSnackBar(
                  'Accept invitation failed. Please try again.');
            }
          } else if (state is SharedSafetyValidateCodeFailedState) {
            if (state.failedState.apiError == NWErrorEnum.sharedCodeInvalid) {
              _hasError = true;
              _rating = null;
            } else {
              _textEditingController.text = '';
              _scaffoldKey.currentState
                  .showCSSnackBar(state.failedState.errorMessage);
            }
          }
        },
        builder: (ctx, state) {
          return Stack(
            children: <Widget>[
              CustomNavigationBar(
                navTitle: 'Accept Invitation',
              ),
              Container(
                padding: EdgeInsets.only(
                  top: CustomNavigationBar.heightNavBar +
                      context.media.viewPadding.top,
                  left: 20,
                  right: 20,
                ),
                child: IgnorePointer(
                  ignoring: state is SharedSafetyProcessingState,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: (context.isSmallDevice) ? 40 : 60),
                      Text(
                        (_invitationCodeValid)
                            ? 'The invitation code entered is valid. Tap "Accept Invitation" to confirm the mutual sharing of Safety Ratings.'
                            : 'Enter the invitation code you\nreceived',
                        textAlign: TextAlign.center,
                        style: context.theme.textTheme.headline5.copyWith(
                          fontSize: 16,
                          color: ColorExt.colorWithHex(0x4F4F4F),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 43),
                      Form(
                        child: IgnorePointer(
                          ignoring: _invitationCodeValid,
                          child: PinCodeTextField(
                            length: 6,
                            obsecureText: false,
                            animationType: AnimationType.fade,
                            textInputType: TextInputType.number,
                            focusNode: _textEditingNode,
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
                                _currentCode = _textEditingController.text;
                                context.bloc<SharedSafetyBloc>().add(
                                      SharedSafetyValidateCodeEvent(
                                        code: _textEditingController.text,
                                      ),
                                    );
                              }
                            },
                            onChanged: (value) {
                              if (_currentCode != null &&
                                  _currentCode != value) {
                                _rating = null;
                                _currentCode = null;
                                setState(() {});
                              }
                            },
                            onTapFocus: () {
                              if (_hasError) {
                                _textEditingController.text = '';
                                _desErrorEnum = null;
                                _hasError = false;
                                _rating = null;
                                _currentCode = null;
                                setState(() {});
                              }
                            },
                          ),
                        ),
                      ),
                      if (_hasError)
                        Text(
                          _desErrorEnum == null
                              ? ''
                              : _desErrorEnum.errorMessage,
                          style: context.theme.textTheme.headline5.copyWith(
                            fontSize: 16,
                            color: ColorExt.colorWithHex(0xEB5757),
                          ),
                        ),
                      SizedBox(height: 50),
                      if (!_invitationCodeValid &&
                          state is SharedSafetyProcessingState)
                        Container(
                          width: 45,
                          height: 45,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            strokeWidth: 3.0,
                          ),
                        ),
                      if (_invitationCodeValid &&
                          !(state is SharedSafetyProcessingState))
                        CustomButtonWidget(
                          title: 'Accept Invitation',
                          width: 257,
                          onPressed: () {
                            context.bloc<SharedSafetyBloc>().add(
                                  SharedSafetyAcceptCodeEvent(
                                    code: _textEditingController.text,
                                  ),
                                );
                          },
                        ),
                      if (_invitationCodeValid) SizedBox(height: 16),
                      if (_invitationCodeValid &&
                          state is SharedSafetyProcessingState)
                        Container(
                          width: 45,
                          height: 45,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            strokeWidth: 3.0,
                          ),
                        ),
                      if (_invitationCodeValid)
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
                              (route) =>
                                  route.settings.name == HomeScreen.routeName,
                            );
                          },
                        ),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
