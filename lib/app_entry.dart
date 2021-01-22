import 'package:chkm8_app/app_config.dart';
import 'package:chkm8_app/bloc/auth/auth_bloc.dart';
import 'package:chkm8_app/bloc/auth/auth_state.dart';
import 'package:chkm8_app/bloc/global/global_bloc.dart';
import 'package:chkm8_app/bloc/global/global_state.dart';
import 'package:chkm8_app/services/navigation_service.dart';
import 'package:chkm8_app/utils/constant.dart';
import 'package:chkm8_app/utils/utils.dart';
import 'package:chkm8_app/wireframe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:chkm8_app/utils/extension.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(AuthInitializeState()),
        ),
        BlocProvider<GlobalBloc>(
          create: (_) => GlobalBloc(
            GlobalInitializeState(),
          ),
        ),
      ],
      child: OverlaySupport(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: GetService().navigatorKey,
          theme: ThemeData(
            primaryColor: Constaint.mainColor,
            primarySwatch: Colors.green,
            highlightColor: Constaint.mainColor.withPercentAlpha(0.2),
            splashColor: Constaint.mainColor.withPercentAlpha(0.3),
            appBarTheme:
                AppBarTheme(textTheme: Utils.getCustomAppBarTextTheme()),
            textTheme: Utils.getCustomTextTheme(),
          ),
          routes: AppWireFrame.routes,
          builder: (context, child) {
            return MediaQuery(
              child: AppConfig.enviroment == AppEnvironment.development
                  ? Banner(
                      message: 'DEV',
                      location: BannerLocation.topEnd,
                      child: child,
                    )
                  : child,
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            );
          },
        ),
      ),
    );
  }
}
