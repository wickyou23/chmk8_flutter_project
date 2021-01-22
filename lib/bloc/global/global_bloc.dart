import 'package:chkm8_app/bloc/global/global_event.dart';
import 'package:chkm8_app/bloc/global/global_state.dart';
import 'package:chkm8_app/bloc/schedule_mutual/schedule_mutual_bloc.dart';
import 'package:chkm8_app/bloc/schedule_mutual/schedule_mutual_state.dart';
import 'package:chkm8_app/bloc/shared_safety/shared_safety_bloc.dart';
import 'package:chkm8_app/bloc/shared_safety/shared_safety_state.dart';
import 'package:chkm8_app/channels/utils_native_channel.dart';
import 'package:chkm8_app/data/middleware/rating_middleware.dart';
import 'package:chkm8_app/data/network_response_state.dart';
import 'package:chkm8_app/enum/lastest_accept_enum.dart';
import 'package:chkm8_app/models/lastest_accept_object.dart';
import 'package:chkm8_app/models/rating_review_object.dart';
import 'package:chkm8_app/models/schedule_mutual_object.dart';
import 'package:chkm8_app/screens/schedule_mutual_rating/schedule_pick_date_rating_screen.dart';
import 'package:chkm8_app/screens/share_safety_rating/create_invitation/invitation_code_success_screen.dart';
import 'package:chkm8_app/services/local_store_service.dart';
import 'package:chkm8_app/services/navigation_service.dart';
import 'package:chkm8_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GlobalBloc extends Bloc<GlobalEvent, GlobalState> {
  final RatingMiddleware _ratingMiddleware = RatingMiddleware();

  GlobalBloc(GlobalState initialState) : super(initialState);

  bool _lastestAcceptIsHandling = false;

  @override
  Future<void> close() {
    appPrint('NotificationBloc closed');
    _ratingMiddleware.close();
    return super.close();
  }

  @override
  Stream<GlobalState> mapEventToState(GlobalEvent event) async* {
    if (event is GlobalGetLastestAccpetEvent) {
      yield* _mapToGlobalGetLastestAccpetEvent(event);
    }
  }

  Stream<GlobalState> _mapToGlobalGetLastestAccpetEvent(
      GlobalGetLastestAccpetEvent event) async* {
    if (_lastestAcceptIsHandling) return;
    _lastestAcceptIsHandling = true;
    ResponseState repo;
    int retry = 1;
    bool isSuccess = false;
    while ((!isSuccess && retry <= 3)) {
      var tmpRepo = await _ratingMiddleware.getLastestAccept();
      if (tmpRepo is ResponseSuccessState) {
        isSuccess = true;
        repo = tmpRepo;
      } else {
        retry += 1;
      }
    }

    var crNavigator = GetService().navigatorKey;
    if (repo is ResponseSuccessState<LastestAcceptObject>) {
      var rpData = repo.responseData;
      if (event.type != null && event.type != rpData.type) {
        _lastestAcceptIsHandling = false;
        return;
      }

      switch (rpData.type) {
        case LastestAcceptEnum.shareRating:
          if (!LocalStoreService().isWaitingAcceptSharedCode ||
              LocalStoreService().safetyCodeWaiting != rpData.code) break;
          UtilsNativeChannel().cancelAllNotificationTray();
          var ratingObj = rpData.data as RatingReviewObject;
          crNavigator.currentState.push(
            MaterialPageRoute(
              builder: (ctx) {
                return BlocProvider<SharedSafetyBloc>(
                  create: (_) => SharedSafetyBloc(
                    SharedSafetyReviewState(rating: ratingObj),
                  ),
                  child: InvitationCodeSuccessScreen(),
                );
              },
              settings:
                  RouteSettings(name: InvitationCodeSuccessScreen.routeName),
            ),
          );
          break;
        case LastestAcceptEnum.schedulingRating:
          if (!LocalStoreService().isWaitingAcceptScheduleCode ||
              LocalStoreService().scheduleCodeWaiting != rpData.code) break;
          UtilsNativeChannel().cancelAllNotificationTray();
          var scheduleObj = rpData.data as ScheduleMutualObject;
          crNavigator.currentState.push(
            MaterialPageRoute(
              builder: (_) => BlocProvider<ScheduleMutualBloc>(
                create: (_) => ScheduleMutualBloc(
                  ScheduleMutualInitializeState(scheduleObj: scheduleObj),
                ),
                child: SchedulePickDateRatingScreen(),
              ),
              settings:
                  RouteSettings(name: SchedulePickDateRatingScreen.routeName),
            ),
          );
          break;
        default:
          break;
      }
    }

    _lastestAcceptIsHandling = false;
  }
}
