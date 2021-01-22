import 'package:chkm8_app/bloc/auth/auth_bloc.dart';
import 'package:chkm8_app/bloc/auth/auth_event.dart';
import 'package:chkm8_app/screens/auth/auth_screen.dart';
import 'package:chkm8_app/screens/auth/selection_gender_screen.dart';
import 'package:chkm8_app/screens/home_screen.dart';
import 'package:chkm8_app/screens/introduce/introduce_screen.dart';
import 'package:chkm8_app/services/local_store_service.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatelessWidget {
  static final routeName = '/';

  Future<void> _handleLogicLaunchingApp(BuildContext context) async {
    Future.delayed(
      Duration(seconds: 2),
      () {
        var crUser = LocalStoreService().currentUser;
        if (crUser != null) {
          context.bloc<AuthBloc>().add(AuthReadyEvent(crUser));
          if (crUser.gender != null) {
            context.navigator.pushReplacementNamed(
              HomeScreen.routeName,
            );
          } else {
            context.navigator.pushReplacementNamed(
              SelectionGenderScreen.routeName,
            );
          }

          return;
        }

        if (!LocalStoreService().isSkipIntroduce) {
          context.navigator.pushReplacementNamed(IntroduceScreen.routeName);
        } else {
          context.navigator.pushReplacementNamed(
            AuthScreen.routeName,
            arguments: false,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _handleLogicLaunchingApp(context);

    return Container(
      child: Image.asset(
        'assets/images/splash_image.png',
        fit: BoxFit.cover,
      ),
    );
  }
}
