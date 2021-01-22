import 'package:chkm8_app/bloc/schedule_mutual/schedule_mutual_bloc.dart';
import 'package:chkm8_app/bloc/schedule_mutual/schedule_mutual_event.dart';
import 'package:chkm8_app/bloc/schedule_mutual/schedule_mutual_state.dart';
import 'package:chkm8_app/screens/home_screen.dart';
import 'package:chkm8_app/screens/schedule_mutual_rating/create_invitation/schedule_create_invitation_code_screen.dart';
import 'package:chkm8_app/utils/constant.dart';
import 'package:chkm8_app/widgets/app_scaffold.dart';
import 'package:chkm8_app/widgets/custom_button_widget.dart';
import 'package:chkm8_app/widgets/custom_navigation_bar.dart';
import 'package:chkm8_app/widgets/custom_textformfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScheduleCreateNicknameScreen extends StatefulWidget {
  static final routeName = '/ScheduleCreateNicknameScreen';

  @override
  _ScheduleCreateNicknameScreenState createState() =>
      _ScheduleCreateNicknameScreenState();
}

class _ScheduleCreateNicknameScreenState
    extends State<ScheduleCreateNicknameScreen> {
  GlobalKey<FormState> _nicknameForm = GlobalKey<FormState>();
  TextEditingController _nicknameEditingController = TextEditingController();

  @override
  void dispose() {
    _nicknameEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: BlocConsumer<ScheduleMutualBloc, ScheduleMutualState>(
          listener: (ctx, state) {},
          builder: (ctx, state) {
            return Stack(
              children: <Widget>[
                CustomNavigationBar(
                  navTitle: 'Schedule Mutual Rating',
                  navTitleColor: Constaint.scheduleRatingColor,
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    top: CustomNavigationBar.heightNavBar +
                        context.media.viewPadding.top,
                    left: 20,
                    right: 20,
                  ),
                  color: Colors.transparent,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 46),
                      Text(
                        'Give this date a nickname',
                        style: context.theme.textTheme.headline5.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Make it unique so you both\ncan recall your experience later',
                        textAlign: TextAlign.center,
                        style: context.theme.textTheme.headline5.copyWith(
                          fontSize: 16,
                          color: Constaint.defaultTextColor,
                        ),
                      ),
                      SizedBox(height: 16),
                      Form(
                        key: _nicknameForm,
                        child: CustomTextFormField(
                          controller: _nicknameEditingController,
                          placeHolder: 'i.e Cheesecake Factory Fun',
                          fontSize: 14,
                          maxLength: 30,
                          inputFormatters: [_FirstUpperCaseFormatter()],
                          textCapitalization: TextCapitalization.sentences,
                          onValidator: (text) {
                            return _validatorNickname(text);
                          },
                          onChanged: (_) {
                            setState(() {});
                          },
                        ),
                      ),
                      SizedBox(height: 27),
                      CustomButtonWidget(
                        wTitle: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Next',
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
                        btnColor: Constaint.scheduleRatingColor,
                        onPressed:
                            _nicknameEditingController.text.trim().isEmpty
                                ? null
                                : () {
                                    context.focus.unfocus();
                                    _handleCreateNickname(state);
                                  },
                      ),
                      SizedBox(height: 16),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Text(
                          'Cancel',
                          style: context.theme.textTheme.headline5.copyWith(
                            fontSize: 18,
                            color: Constaint.defaultTextColor,
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
              ],
            );
          },
        ),
      ),
    );
  }

  void _handleCreateNickname(ScheduleMutualState crState) {
    if (!_nicknameForm.currentState.validate()) {
      return;
    }

    var initState = crState;
    if (initState is ScheduleMutualInitializeState) {
      context.bloc<ScheduleMutualBloc>().add(
            ScheduleMutualUpdateDataEvent(
              newScheduleObj: initState.scheduleObj.copyWith(
                nickName: _nicknameEditingController.text.trim(),
              ),
            ),
          );
    }

    context.navigator.push(
      MaterialPageRoute(
        builder: (_) => BlocProvider<ScheduleMutualBloc>.value(
          value: context.bloc<ScheduleMutualBloc>(),
          child: ScheduleCreateInvitationCodeScreen(),
        ),
        settings: RouteSettings(
          name: ScheduleCreateInvitationCodeScreen.routeName,
        ),
      ),
    );
  }

  String _validatorNickname(String text) {
    if (text.isEmpty) {
      return 'Nickname is required';
    }

    if (text.length > 30) {
      return 'Let\'s keep the nickname to 30 characters or less';
    }

    return null;
  }
}

class _FirstUpperCaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toFirstUpperCase(),
      selection: TextSelection.collapsed(offset: newValue.text.length),
    );
  }
}
