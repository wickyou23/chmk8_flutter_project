import 'package:chkm8_app/bloc/rating/given_rating_event.dart';
import 'package:chkm8_app/bloc/rating/given_rating_state.dart';
import 'package:chkm8_app/data/middleware/rating_middleware.dart';
import 'package:chkm8_app/data/network_response_state.dart';
import 'package:chkm8_app/models/history_rating_object.dart';
import 'package:chkm8_app/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GivenRatingBloc extends Bloc<GivenRatingEvent, GivenRatingState> {
  final RatingMiddleware _middleware = RatingMiddleware();

  GivenRatingBloc(GivenRatingState initialState) : super(initialState);

  @override
  Future<void> close() {
    appPrint('GivenRatingBloc closed');
    _middleware.close();
    return super.close();
  }

  @override
  Stream<GivenRatingState> mapEventToState(event) async* {
    if (event is GivenRatingGetListEvent) {
      yield* _mapToGivenRatingGetListEvent(event);
    }
  }

  Stream<GivenRatingState> _mapToGivenRatingGetListEvent(
      GivenRatingGetListEvent event) async* {
    var crState = this.state;
    List<HistoryRatingObject> gList = [];
    if (crState is GivenRatingListReadyState) {
      gList = crState.givenList;
    }

    yield GivenRatingListProcessingState();
    var repo = await _middleware.getGivenRatingList();
    if (repo is ResponseSuccessState<List<HistoryRatingObject>>) {
      yield GivenRatingGetListSuccessState();
      yield GivenRatingListReadyState(
        givenList: repo.responseData,
      );
    } else if (repo is ResponseFailedState) {
      yield GivenRatingGetListFailedState(failedState: repo);
      yield GivenRatingListReadyState(
        givenList: gList,
      );
    }
  }
}
