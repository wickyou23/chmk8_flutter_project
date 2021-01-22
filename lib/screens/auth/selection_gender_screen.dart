import 'package:chkm8_app/bloc/auth/auth_bloc.dart';
import 'package:chkm8_app/bloc/auth/auth_event.dart';
import 'package:chkm8_app/bloc/auth/auth_state.dart';
import 'package:chkm8_app/enum/gender_enum.dart';
import 'package:chkm8_app/screens/auth/verification_code_success_screen.dart';
import 'package:chkm8_app/utils/constant.dart';
import 'package:chkm8_app/utils/utils.dart';
import 'package:chkm8_app/widgets/app_scaffold.dart';
import 'package:chkm8_app/widgets/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectionGenderScreen extends StatefulWidget {
  static final routeName = '/SelectionGenderScreen';

  @override
  _SelectionGenderScreenState createState() => _SelectionGenderScreenState();
}

class _SelectionGenderScreenState extends State<SelectionGenderScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Gender _genderSelected;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AppScaffold(
        scKey: _scaffoldKey,
        body: Stack(
          children: [
            CustomNavigationBar(
              navTitle: 'Almost done!',
              isShowBack: false,
            ),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (_, state) {
                if (state is AuthUpdateGenderSuccessState) {
                  context.navigator.pushNamedAndRemoveUntil(
                    VerificationCodeSuccessScreen.routeName,
                    (route) => false,
                  );
                } else if (state is AuthUpdateGenderFailedState) {
                  _genderSelected = null;
                  _scaffoldKey.currentState.showCSSnackBar(
                      'Update gender failed. Please try again.');
                }
              },
              builder: (_, state) {
                return IgnorePointer(
                  ignoring: state is AuthProcessingState,
                  child: Container(
                    margin: EdgeInsets.only(
                      top: CustomNavigationBar.heightNavBar +
                          context.media.viewPadding.top,
                      left: 20,
                      right: 20,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 50),
                        Text(
                          'Select your gender',
                          style: context.theme.textTheme.headline5.copyWith(
                            fontSize: 16,
                            color: Constaint.defaultTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildButton(
                              gender: Gender.male,
                              isSelected: _genderSelected == Gender.male,
                              onPressed: () {
                                _genderSelected = Gender.male;
                                context.bloc<AuthBloc>().add(
                                      AuthUpdateGenderEvent(
                                          gender: _genderSelected),
                                    );
                              },
                            ),
                            _buildButton(
                              gender: Gender.female,
                              isSelected: _genderSelected == Gender.female,
                              onPressed: () {
                                _genderSelected = Gender.female;
                                context.bloc<AuthBloc>().add(
                                      AuthUpdateGenderEvent(
                                          gender: _genderSelected),
                                    );
                              },
                            ),
                            _buildButton(
                              gender: Gender.other,
                              isSelected: _genderSelected == Gender.other,
                              onPressed: () {
                                _genderSelected = Gender.other;
                                context.bloc<AuthBloc>().add(
                                      AuthUpdateGenderEvent(
                                          gender: _genderSelected),
                                    );
                              },
                            ),
                          ],
                        ),
                        if (state is AuthProcessingState) SizedBox(height: 50),
                        if (state is AuthProcessingState)
                          Utils.getLoadingWidget()
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
      {@required Gender gender,
      @required bool isSelected,
      @required Function onPressed}) {
    return Container(
      key: ValueKey(gender.title),
      width: (context.media.size.width - 60) / 3,
      height: (context.media.size.width - 60) / 3,
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.hardEdge,
        color: isSelected ? ColorExt.colorWithHex(0xEFFAF5) : Colors.white,
        margin: EdgeInsets.zero,
        child: FlatButton(
          onPressed: onPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                gender.icon,
                width: 33,
                height: 33,
              ),
              SizedBox(height: 6),
              Text(
                gender.title,
                style: context.theme.textTheme.headline5.copyWith(
                  fontSize: 18,
                  color: gender.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
