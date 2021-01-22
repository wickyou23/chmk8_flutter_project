import 'package:chkm8_app/bloc/notification/notification_bloc.dart';
import 'package:chkm8_app/bloc/notification/notification_state.dart';
import 'package:chkm8_app/bloc/rating/given_rating_bloc.dart';
import 'package:chkm8_app/bloc/rating/given_rating_state.dart';
import 'package:chkm8_app/bloc/rating/pending_rating_bloc.dart';
import 'package:chkm8_app/bloc/rating/pending_rating_state.dart';
import 'package:chkm8_app/bloc/schedule_mutual/schedule_mutual_bloc.dart';
import 'package:chkm8_app/bloc/schedule_mutual/schedule_mutual_state.dart';
import 'package:chkm8_app/bloc/shared_safety/shared_safety_bloc.dart';
import 'package:chkm8_app/bloc/shared_safety/shared_safety_state.dart';
import 'package:chkm8_app/channels/utils_native_channel.dart';
import 'package:chkm8_app/models/history_rating_object.dart';
import 'package:chkm8_app/screens/auth/auth_screen.dart';
import 'package:chkm8_app/screens/auth/change_my_phone.dart';
import 'package:chkm8_app/screens/auth/change_my_phone_success.dart';
import 'package:chkm8_app/screens/auth/selection_gender_screen.dart';
import 'package:chkm8_app/screens/auth/verification_code_screen.dart';
import 'package:chkm8_app/screens/auth/verification_code_success_screen.dart';
import 'package:chkm8_app/screens/home_screen.dart';
import 'package:chkm8_app/screens/introduce/introduce_screen.dart';
import 'package:chkm8_app/screens/privacy/policy_privacy_screen.dart';
import 'package:chkm8_app/screens/privacy/terms_of_service_screen.dart';
import 'package:chkm8_app/screens/profile/my_rating_inform_screen.dart';
import 'package:chkm8_app/screens/rate_your_date/overall_rating_not_happen.dart';
import 'package:chkm8_app/screens/rate_your_date/rate_dashboard_screen.dart';
import 'package:chkm8_app/screens/rate_your_date/rating_success_screen.dart';
import 'package:chkm8_app/screens/rate_your_date/start_rating_intro_screen.dart';
import 'package:chkm8_app/screens/schedule_mutual_rating/create_invitation/schedule_create_invitation_code_screen.dart';
import 'package:chkm8_app/screens/schedule_mutual_rating/create_invitation/schedule_create_nickname_screen.dart';
import 'package:chkm8_app/screens/schedule_mutual_rating/create_invitation/schedule_invitation_code_countdown_screen.dart';
import 'package:chkm8_app/screens/schedule_mutual_rating/create_invitation/schedule_mutual_rating_dashboard_screen.dart';
import 'package:chkm8_app/screens/schedule_mutual_rating/create_invitation/schedule_mutual_rating_screen.dart';
import 'package:chkm8_app/screens/schedule_mutual_rating/create_invitation/schedule_rating_selection_screen.dart';
import 'package:chkm8_app/screens/schedule_mutual_rating/schedule_pick_date_rating_screen.dart';
import 'package:chkm8_app/screens/share_safety_rating/accept_invitation/accept_invitation_screen.dart';
import 'package:chkm8_app/screens/share_safety_rating/create_invitation/create_invitation_code_screen.dart';
import 'package:chkm8_app/screens/share_safety_rating/create_invitation/invitation_code_countdown_screen.dart';
import 'package:chkm8_app/screens/share_safety_rating/create_invitation/invitation_code_detail_screen.dart';
import 'package:chkm8_app/screens/share_safety_rating/create_invitation/share_safety_rating_screen.dart';
import 'package:chkm8_app/screens/splash/splash_screen.dart';
import 'package:chkm8_app/services/fcm_service.dart';
import 'package:chkm8_app/services/local_store_service.dart';
import 'package:chkm8_app/services/navigation_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'utils/extension.dart';

class AppWireFrame {
  static final Map<String, WidgetBuilder> routes = {
    SplashScreen.routeName: (_) => SplashScreen(),
    AuthScreen.routeName: (ctx) {
      var isShowSignupFirst = ctx.routeArg as bool ?? true;
      return AuthScreen(
        isShowSignupFirst: isShowSignupFirst,
      );
    },
    VerificationCodeScreen.routeName: (ctx) {
      var type =
          ctx.routeArg as VerificationCodeType ?? VerificationCodeType.signUp;
      return VerificationCodeScreen(
        type: type,
      );
    },
    VerificationCodeSuccessScreen.routeName: (_) =>
        VerificationCodeSuccessScreen(),
    HomeScreen.routeName: (_) => MultiBlocProvider(
          providers: [
            BlocProvider<NotificationBloc>(
              create: (_) => NotificationBloc(
                NotificationInitializeState(),
              ),
            ),
          ],
          child: HomeScreen(),
        ),
    IntroduceScreen.routeName: (_) => IntroduceScreen(),
    ChangeMyPhoneScreen.routeName: (_) => ChangeMyPhoneScreen(),
    ChangeMyPhoneSuccess.routeName: (_) => ChangeMyPhoneSuccess(),
    ShareSafetyRatingScreen.routeName: (_) => ShareSafetyRatingScreen(),
    CreateInvitationCodeScreen.routeName: (ctx) {
      return BlocProvider<SharedSafetyBloc>(
        create: (ctx) => SharedSafetyBloc(SharedSafetyInitializeState()),
        child: CreateInvitationCodeScreen(),
      );
    },
    InvitationCodeDetailScreen.routeName: (_) => InvitationCodeDetailScreen(),
    InvitationCodeCountDownScreen.routeName: (ctx) {
      return BlocProvider<SharedSafetyBloc>(
        create: (_) => SharedSafetyBloc(
          SharedSafetyGetMyCodeSuccessState(
            sharedSafetyCode: ctx.routeArg as String,
          ),
        ),
        child: InvitationCodeCountDownScreen(),
      );
    },
    AcceptInvitationScreen.routeName: (_) {
      return BlocProvider<SharedSafetyBloc>(
        create: (_) => SharedSafetyBloc(SharedSafetyInitializeState()),
        child: AcceptInvitationScreen(),
      );
    },
    TermsOfServiceScreen.routeName: (_) => TermsOfServiceScreen(),
    PolicyPrivacyScreen.routeName: (_) => PolicyPrivacyScreen(),
    ScheduleMutualRatingDashboardScreen.routeName: (_) =>
        ScheduleMutualRatingDashboardScreen(),
    ScheduleRatingSelectionScreen.routeName: (_) =>
        ScheduleRatingSelectionScreen(),
    ScheduleMutualRatingScreen.routeName: (_) => ScheduleMutualRatingScreen(),
    ScheduleCreateNicknameScreen.routeName: (_) =>
        ScheduleCreateNicknameScreen(),
    ScheduleCreateInvitationCodeScreen.routeName: (_) =>
        ScheduleCreateInvitationCodeScreen(),
    ScheduleInvitationCodeCountDownScreen.routeName: (_) =>
        ScheduleInvitationCodeCountDownScreen(),
    RateDashboardScreen.routeName: (_) => MultiBlocProvider(
          providers: [
            BlocProvider<PendingRatingBloc>(
              create: (_) =>
                  PendingRatingBloc(PendingRatingListInitializeState()),
            ),
            BlocProvider<GivenRatingBloc>(
              create: (_) => GivenRatingBloc(GivenRatingListInitializeState()),
            ),
          ],
          child: RateDashboardScreen(),
        ),
    StartRatingIntroScreen.routeName: (ctx) {
      var item = ctx.routeArg as HistoryRatingObject;
      return BlocProvider<ScheduleMutualBloc>(
        create: (ctx) => ScheduleMutualBloc(
          ScheduleMutualInitializeState(scheduleObj: null),
        ),
        child: StartRatingIntroScreen(ratingObj: item),
      );
    },
    RatingSuccessScreen.routeName: (_) => RatingSuccessScreen(),
    MyRatingInformScreen.routeName: (_) => MyRatingInformScreen(),
    SchedulePickDateRatingScreen.routeName: (_) =>
        SchedulePickDateRatingScreen(),
    SelectionGenderScreen.routeName: (_) => SelectionGenderScreen(),
    OverallRatingNotHappen.routeName: (_) => OverallRatingNotHappen(),
  };

  static void logout() {
    FCMService().deleteInstanceID();
    UtilsNativeChannel().cancelAllNotificationTray();
    LocalStoreService().logout();
    var navigatorState = GetService().navigatorKey.currentState;
    if (navigatorState.context.route?.settings?.name == AuthScreen.routeName) {
      return;
    }

    navigatorState.pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => AuthScreen(
          isShowSignupFirst: false,
          authLogout: true,
        ),
        transitionDuration: Duration(seconds: 0),
      ),
      (route) => false,
    );
  }
}
