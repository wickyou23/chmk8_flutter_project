import 'package:chkm8_app/bloc/auth/auth_bloc.dart';
import 'package:chkm8_app/bloc/auth/auth_event.dart';
import 'package:chkm8_app/models/auth_user.dart';
import 'package:chkm8_app/screens/home_screen.dart';
import 'package:chkm8_app/services/local_store_service.dart';
import 'package:chkm8_app/widgets/app_scaffold.dart';
import 'package:chkm8_app/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chkm8_app/utils/constant.dart';

class VerificationCodeSuccessScreen extends StatelessWidget {
  static final routeName = '/VerificationCodeSuccessScreen';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 110),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Image.asset(
              'assets/images/bg_verification_code_success.png',
              width: 164,
              height: 164 * 0.9410569105691057,
            ),
            SizedBox(height: 77),
            Text(
              'Success! You\'re verified!',
              textAlign: TextAlign.center,
              style: context.theme.textTheme.headline5.copyWith(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Constaint.defaultTextColor,
              ),
            ),
            SizedBox(height: 20),
            CustomButtonWidget(
              title: 'Go to Home',
              onPressed: () {
                AuthUser crUser = LocalStoreService().currentUser;
                if (crUser != null) {
                  context.bloc<AuthBloc>().add(AuthReadyEvent(crUser));
                }

                context.navigator.pushReplacementNamed(HomeScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
