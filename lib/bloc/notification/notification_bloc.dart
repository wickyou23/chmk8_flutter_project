import 'package:chkm8_app/bloc/notification/notification_event.dart';
import 'package:chkm8_app/bloc/notification/notification_state.dart';
import 'package:chkm8_app/data/middleware/notification_middleware.dart';
import 'package:chkm8_app/data/network_response_state.dart';
import 'package:chkm8_app/models/notification_object.dart';
import 'package:chkm8_app/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationMiddleware _middleware = NotificationMiddleware();

  NotificationBloc(NotificationState initialState) : super(initialState);

  @override
  Future<void> close() {
    appPrint('NotificationBloc closed');
    _middleware.close();
    return super.close();
  }

  @override
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {
    if (event is NotificationGetNotiListEvent) {
      yield* _mapToNotificationGetNotiListEvent(event);
    }
  }

  Stream<NotificationState> _mapToNotificationGetNotiListEvent(
      NotificationGetNotiListEvent event) async* {
    List<NotificationObject> notiObjs = [];
    var crState = this.state;
    if (crState is NotificationListReadyState) {
      notiObjs = crState.notiObjs;
    }

    yield NotificationProcessingState();
    var repo = await _middleware.getNotificationList();
    if (repo is ResponseSuccessState<List<NotificationObject>>) {
      yield NotificationGetNotiListSuccessState();
      notiObjs = repo.responseData;
      notiObjs.sort((a, b) => b.time.compareTo(a.time));
      yield NotificationListReadyState(notiObjs: notiObjs);
    } else if (repo is ResponseFailedState) {
      yield NotificationGetNotiListFailedState(failedState: repo);
      yield NotificationListReadyState(notiObjs: notiObjs);
    } else {
      yield NotificationListReadyState(notiObjs: notiObjs);
    }
  }
}
