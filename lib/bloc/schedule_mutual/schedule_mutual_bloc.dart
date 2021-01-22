import 'package:bloc/bloc.dart';
import 'package:chkm8_app/bloc/schedule_mutual/schedule_mutual_event.dart';
import 'package:chkm8_app/bloc/schedule_mutual/schedule_mutual_state.dart';
import 'package:chkm8_app/data/middleware/schedule_mutual_middleware.dart';
import 'package:chkm8_app/data/network_response_state.dart';
import 'package:chkm8_app/models/schedule_mutual_object.dart';
import 'package:chkm8_app/utils/utils.dart';

class ScheduleMutualBloc
    extends Bloc<ScheduleMutualEvent, ScheduleMutualState> {
  final ScheduleMutualMiddleware _middleware = ScheduleMutualMiddleware();

  ScheduleMutualBloc(ScheduleMutualState initialState) : super(initialState);

  @override
  Future<void> close() {
    appPrint('ScheduleMutualBloc closed');
    _middleware.close();
    return super.close();
  }

  @override
  Stream<ScheduleMutualState> mapEventToState(
      ScheduleMutualEvent event) async* {
    if (event is ScheduleMutualUpdateDataEvent) {
      yield* _mapToScheduleMutualUpdateDataEvent(event);
    } else if (event is ScheduleMutualGetSharedCodeEvent) {
      yield* _mapToScheduleMutualGetSharedCodeEvent(event);
    } else if (event is ScheduleMutualAcceptSharedCodeEvent) {
      yield* _mapToScheduleMutualAcceptSharedCodeEvent(event);
    } else if (event is ScheduleMutualValidateSharedCodeEvent) {
      yield* _mapToScheduleMutualValidateSharedCodeEvent(event);
    } else if (event is ScheduleMutualCancelSharedCodeEvent) {
      yield* _mapToScheduleMutualCancelSharedCodeEvent(event);
    } else if (event is ScheduleMutualSetRemindRatingEvent) {
      yield* _mapToScheduleMutualSetRemindRatingEvent(event);
    } else if (event is ScheduleMutualCheckRatedEvent) {
      yield* _mapToScheduleMutualCheckRatedEvent(event);
    }
  }

  Stream<ScheduleMutualState> _mapToScheduleMutualUpdateDataEvent(
      ScheduleMutualUpdateDataEvent event) async* {
    if (this.state is ScheduleMutualInitializeState) {
      yield ScheduleMutualInitializeState(scheduleObj: event.newScheduleObj);
    }
  }

  Stream<ScheduleMutualState> _mapToScheduleMutualGetSharedCodeEvent(
      ScheduleMutualGetSharedCodeEvent event) async* {
    yield ScheduleMutualProcessingState();
    var repo = await _middleware.getMySharedScheduleCode(
      event.scheduleObj.pickDate.millisecondsSinceEpoch,
      event.scheduleObj.nickName,
    );

    if (repo is ResponseSuccessState<String>) {
      yield ScheduleMutualGetSharedCodeSuccessState(
        scheduleObj: event.scheduleObj.copyWith(sharedCode: repo.responseData),
      );
    } else if (repo is ResponseFailedState) {
      yield ScheduleMutualGetSharedCodeFailedState(failedState: repo);
    }
  }

  Stream<ScheduleMutualState> _mapToScheduleMutualAcceptSharedCodeEvent(
      ScheduleMutualAcceptSharedCodeEvent event) async* {
    yield ScheduleMutualProcessingState();
    var repo = await _middleware.acceptSharedScheduleCode(event.code);
    if (repo is ResponseSuccessState<ScheduleMutualObject>) {
      yield ScheduleMutualAcceptSharedCodeSuccessState(
          scheduleObj: repo.responseData);
    } else if (repo is ResponseFailedState) {
      yield ScheduleMutualAcceptSharedCodeFailedState(failedState: repo);
    }
  }

  Stream<ScheduleMutualState> _mapToScheduleMutualValidateSharedCodeEvent(
      ScheduleMutualValidateSharedCodeEvent event) async* {
    yield ScheduleMutualProcessingState();
    var repo = await _middleware.validateScheduleSharedCode(event.code);
    if (repo is ResponseSuccessState) {
      yield ScheduleMutualValidateSharedCodeSuccessState();
    } else if (repo is ResponseFailedState) {
      yield ScheduleMutualValidateSharedCodeFailedState(failedState: repo);
    }
  }

  Stream<ScheduleMutualState> _mapToScheduleMutualCancelSharedCodeEvent(
      ScheduleMutualCancelSharedCodeEvent event) async* {
    var repo = await _middleware.cancelSharedScheduleCode(event.code);
    if (repo is ResponseSuccessState) {
    } else if (repo is ResponseFailedState) {
    }
  }

  Stream<ScheduleMutualState> _mapToScheduleMutualSetRemindRatingEvent(
      ScheduleMutualSetRemindRatingEvent event) async* {
    var repo = await _middleware.setScheduleRemindRating(event.id, event.time);
    if (repo is ResponseSuccessState) {
    } else if (repo is ResponseFailedState) {
    }
  }

  Stream<ScheduleMutualState> _mapToScheduleMutualCheckRatedEvent(
      ScheduleMutualCheckRatedEvent event) async* {
    yield ScheduleMutualProcessingState();
    var repo = await _middleware.checkScheduleRated(event.scheduleId);
    if (repo is ResponseSuccessState) {
      yield ScheduleMutualCheckRateSuccessState(
          isRated: repo.responseData as bool ?? false);
    } else if (repo is ResponseFailedState) {
      yield ScheduleMutualCheckRateFailedState(failedState: repo);
    }
  }
}
