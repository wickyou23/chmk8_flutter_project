import 'dart:async';
import 'dart:io';
import 'package:chkm8_app/bloc/auth/auth_bloc.dart';
import 'package:chkm8_app/bloc/auth/auth_event.dart';
import 'package:chkm8_app/bloc/global/global_bloc.dart';
import 'package:chkm8_app/bloc/global/global_event.dart';
import 'package:chkm8_app/bloc/notification/notification_bloc.dart';
import 'package:chkm8_app/bloc/notification/notification_event.dart';
import 'package:chkm8_app/enum/home_tab_enum.dart';
import 'package:chkm8_app/screens/tabs/dashboard_screen.dart';
import 'package:chkm8_app/screens/tabs/faq_screen.dart';
import 'package:chkm8_app/screens/tabs/my_profile_screen.dart';
import 'package:chkm8_app/screens/tabs/notification_screen.dart';
import 'package:chkm8_app/services/fcm_service.dart';
import 'package:chkm8_app/services/local_store_service.dart';
import 'package:chkm8_app/services/notification_service.dart';
import 'package:chkm8_app/utils/extension.dart';
import 'package:chkm8_app/utils/utils.dart';
import 'package:chkm8_app/widgets/app_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  static final routeName = '/HomeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  HomeTab _tabSelected = HomeTab.dashboard;
  bool _hasNewNotification = false;
  StreamSubscription<NotificationServiceObject> _subscription;

  @override
  void initState() {
    FCMService().config();
    _listenerNotification();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (LocalStoreService().isWaitingAcceptSharedCode ||
          LocalStoreService().isWaitingAcceptScheduleCode) {
        context.bloc<GlobalBloc>().add(GlobalGetLastestAccpetEvent());
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    appPrint('TabbarScreen dispose');
    _subscription.cancel();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  Widget _getWidgetBySelectedIndex() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 250),
      child: _initWidgetBySelectedIndex(),
    );
  }

  Widget _initWidgetBySelectedIndex() {
    switch (_tabSelected) {
      case HomeTab.dashboard:
        return DashboardScreen(
          key: HomeTab.dashboard.keyValue,
        );
      case HomeTab.profile:
        return MyProfileScreen(
          key: HomeTab.profile.keyValue,
        );
      case HomeTab.notification:
        return NotificationScreen(
          key: HomeTab.notification.keyValue,
        );
      case HomeTab.faq:
        return FAQScreen(
          key: HomeTab.faq.keyValue,
        );
      default:
        return null;
    }
  }

  void _listenerNotification() {
    _subscription = NotificationService().listen((event) {
      switch (event.name) {
        case NotificationName.HOME_SCREEN_CHANGE_TAB:
          var newTab = event.value as HomeTab ?? HomeTab.dashboard;
          if (newTab != _tabSelected) {
            _tabSelected = newTab;
            setState(() {});
          }
          break;
        case NotificationName.NEW_NOTIFICATION:
          context.bloc<NotificationBloc>().add(NotificationGetNotiListEvent());
          if (_tabSelected != HomeTab.notification) {
            _hasNewNotification = true;
            setState(() {});
          }
          break;
        case NotificationName.NEED_TO_RELOAD_NOTIFICATION:
          context.bloc<NotificationBloc>().add(NotificationGetNotiListEvent());
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _getWidgetBySelectedIndex(),
      bottomNavigationBar: _androidTabbar(),
    );
  }

  BottomNavigationBar _androidTabbar() {
    return BottomNavigationBar(
      items: [
        _createBottomBar('ic_home_tabbar'),
        _createBottomBar('ic_profile_tabbar'),
        _createBottomBar(
          'ic_notification_tabbar',
          hasBadge: _hasNewNotification,
        ),
        _createBottomBar('ic_about_tabbar'),
      ],
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      currentIndex: _tabSelected.rawValue,
      selectedItemColor: context.theme.primaryColor,
      onTap: (index) {
        setState(() {
          _tabSelected = HomeTabExt.initRawValue(index);
          if (_tabSelected == HomeTab.notification && _hasNewNotification) {
            _hasNewNotification = false;
          }
        });
      },
    );
  }

  BottomNavigationBarItem _createBottomBar(
    String iconNamed, {
    bool hasBadge = false,
  }) {
    return BottomNavigationBarItem(
      icon: Stack(
        children: [
          ImageIcon(
            AssetImage("assets/images/$iconNamed.png"),
          ),
          if (hasBadge)
            Positioned(
              right: 0,
              top: 0,
              child: Material(
                color: Colors.redAccent,
                type: MaterialType.circle,
                child: Container(
                  height: 10,
                  width: 10,
                  child: null,
                ),
              ),
            ),
        ],
      ),
      title: Container(),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        appPrint('AppLifecycleState.resumed');
        _handleLastestAccpetCode();
        break;
      default:
        break;
    }
  }

  Future<void> _handleLastestAccpetCode() async {
    if (Platform.isIOS) {
      await Future.delayed(Duration(seconds: 1));
    }

    if (FCMService().isBusy) return;

    context.bloc<AuthBloc>().add(AuthGetMyRatingEvent());
    if (LocalStoreService().isWaitingAcceptSharedCode ||
        LocalStoreService().isWaitingAcceptScheduleCode) {
      context.bloc<GlobalBloc>().add(GlobalGetLastestAccpetEvent());
    }
  }
}
