import 'package:chkm8_app/bloc/rating/pending_rating_event.dart';
import 'package:chkm8_app/bloc/rating/pending_rating_state.dart';
import 'package:chkm8_app/data/middleware/rating_middleware.dart';
import 'package:chkm8_app/data/network_response_state.dart';
import 'package:chkm8_app/models/history_rating_object.dart';
import 'package:chkm8_app/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PendingRatingBloc extends Bloc<PendingRatingEvent, PendingRatingState> {
  final RatingMiddleware _middleware = RatingMiddleware();

  PendingRatingBloc(PendingRatingState initialState) : super(initialState);

  @override
  Future<void> close() {
    appPrint('PendingRatingBloc closed');
    _middleware.close();
    return super.close();
  }

  @override
  Stream<PendingRatingState> mapEventToState(event) async* {
    if (event is PendingRatingGetListEvent) {
      yield* _mapToPendingRatingGetListEvent(event);
    }
  }

  Stream<PendingRatingState> _mapToPendingRatingGetListEvent(
      PendingRatingGetListEvent event) async* {
    var crState = this.state;
    List<HistoryRatingObject> pList = [];
    if (crState is PendingRatingListReadyState) {
      pList = crState.pendingList;
    }

    yield PendingRatingListProcessingState();
    var repo = await _middleware.getPendingRatingList();
    if (repo is ResponseSuccessState<List<HistoryRatingObject>>) {
      yield PendingRatingGetListSuccessState();
      yield PendingRatingListReadyState(
        pendingList: repo.responseData,
      );
    } else if (repo is ResponseFailedState) {
      yield PendingRatingGetListFailedState(failedState: repo);
      yield PendingRatingListReadyState(
        pendingList: pList,
      );
    }
  }
}
