import 'package:bloc/bloc.dart';
import 'package:chkm8_app/bloc/rating/rating_event.dart';
import 'package:chkm8_app/bloc/rating/rating_state.dart';
import 'package:chkm8_app/data/middleware/rating_middleware.dart';
import 'package:chkm8_app/data/network_response_state.dart';
import 'package:chkm8_app/data/repository/rating_repository.dart';
import 'package:chkm8_app/models/history_rating_object.dart';
import 'package:chkm8_app/utils/common_key.dart';
import 'package:chkm8_app/utils/utils.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  final RatingRepository _repo = RatingRepository();
  final RatingMiddleware _middleware = RatingMiddleware();

  RatingBloc(RatingState initialState) : super(initialState);

  @override
  Stream<RatingState> mapEventToState(RatingEvent event) async* {
    if (event is RatingSavedEvent) {
      yield* _mapToRatingSavedEvent(event);
    } else if (event is RatingCompletionEvent) {
      yield* _mapToRatingCompletedEvent(event);
    } else if (event is OverrallRatingEvent) {
      yield* _mapToOverrallRatingEvent(event);
    }
  }

  @override
  Future<void> close() {
    appPrint('RatingBloc closed');
    _middleware.close();
    return super.close();
  }

  Stream<RatingState> _mapToRatingSavedEvent(RatingSavedEvent event) async* {
    RatingReadyState readyState = this.state as RatingReadyState;
    if (readyState == null) {
      return;
    }

    _repo.saveRating(readyState.crRating);
  }

  Stream<RatingState> _mapToRatingCompletedEvent(
      RatingCompletionEvent event) async* {
    yield* _handleRating();
  }

  Stream<RatingState> _mapToOverrallRatingEvent(
      OverrallRatingEvent event) async* {
    _repo.addOverall(
      scheduleId: event.scheduleId,
      overallKey: event.overallKey,
      overallReason: event.overallReason,
    );

    if (event.overallKey == CommonKey.NOT_HAPPEN) {
      yield* _handleRating();
    } else {
      HistoryRatingObject hRatingObj;
      var crState = this.state;
      if (crState is OverallRatingReadyState) {
        hRatingObj = crState.historyRating;
      }
      
      yield OverallRatingCompletionState();
      if (hRatingObj != null) {
        yield OverallRatingReadyState(historyRating: hRatingObj);
      }
    }
  }

  Stream<RatingState> _handleRating() async* {
    yield RatingProcessingState();
    var response = await _middleware.submitRating(_repo);
    if (response is ResponseSuccessState) {
      _repo.clean();
      yield RatingCompletionSuccessState();
    } else if (response is ResponseFailedState) {
      yield RatingCompletionFailedState(failedState: response);
    }
  }
}
