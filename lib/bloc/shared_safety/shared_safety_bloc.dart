import 'package:bloc/bloc.dart';
import 'package:chkm8_app/bloc/shared_safety/shared_safety_event.dart';
import 'package:chkm8_app/bloc/shared_safety/shared_safety_state.dart';
import 'package:chkm8_app/data/middleware/shared_safety_middleware.dart';
import 'package:chkm8_app/data/network_response_state.dart';
import 'package:chkm8_app/models/rating_review_object.dart';
import 'package:chkm8_app/utils/utils.dart';

class SharedSafetyBloc extends Bloc<SharedSafetyEvent, SharedSafetyState> {
  final SharedSafetyMiddleware _middleware = SharedSafetyMiddleware();

  SharedSafetyBloc(SharedSafetyState initialState) : super(initialState);

  @override
  Future<void> close() {
    appPrint('SharedSafetyBloc closed');
    _middleware.close();
    return super.close();
  }

  @override
  Stream<SharedSafetyState> mapEventToState(SharedSafetyEvent event) async* {
    if (event is SharedSafetyGetMyCodeEvent) {
      yield* _mapToSharedSafetyGetMyCodeEvent(event);
    } else if (event is SharedSafetyAcceptCodeEvent) {
      yield* _mapToSharedSafetyAcceptCodeEvent(event);
    } else if (event is SharedSafetyValidateCodeEvent) {
      yield* _mapToSharedSafetyValidateCodeEvent(event);
    } else if (event is SharedSafetCancelInvitationCodeEvent) {
      yield* _mapToSharedSafetCancelInvitationCodeEvent(event);
    }
  }

  Stream<SharedSafetyState> _mapToSharedSafetyGetMyCodeEvent(
      SharedSafetyGetMyCodeEvent event) async* {
    yield SharedSafetyProcessingState();
    var repo = await _middleware.getMySharedSafetyCode();
    if (repo is ResponseSuccessState) {
      var myCode = repo.responseData as String ?? '';
      yield SharedSafetyGetMyCodeSuccessState(sharedSafetyCode: myCode);
    } else if (repo is ResponseFailedState) {
      yield SharedSafetyGetMyCodeFailedState(failedState: repo);
    }
  }

  Stream<SharedSafetyState> _mapToSharedSafetyAcceptCodeEvent(
      SharedSafetyAcceptCodeEvent event) async* {
    yield SharedSafetyProcessingState();
    var repo = await _middleware.acceptSharedSafetyCode(event.code);
    if (repo is ResponseSuccessState<RatingReviewObject>) {
      yield SharedSafetyAcceptCodeSuccessState(rating: repo.responseData);
    } else if (repo is ResponseFailedState) {
      yield SharedSafetyAcceptCodeFailedState(failedState: repo);
    }
  }

  Stream<SharedSafetyState> _mapToSharedSafetyValidateCodeEvent(
      SharedSafetyValidateCodeEvent event) async* {
    yield SharedSafetyProcessingState();
    var repo = await _middleware.validateSharedSafetyCode(event.code);
    if (repo is ResponseSuccessState) {
      yield SharedSafetyValidateCodeSuccessState();
    } else if (repo is ResponseFailedState) {
      yield SharedSafetyValidateCodeFailedState(failedState: repo);
    }
  }

  Stream<SharedSafetyState> _mapToSharedSafetCancelInvitationCodeEvent(
      SharedSafetCancelInvitationCodeEvent event) async* {
    var repo = await _middleware.cancelSharedSafetyCode(event.code);
    if (repo is ResponseSuccessState) {
    } else if (repo is ResponseFailedState) {
    }
  }
}
