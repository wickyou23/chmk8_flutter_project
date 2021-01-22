import 'package:bloc/bloc.dart';
import 'package:chkm8_app/bloc/auth/auth_event.dart';
import 'package:chkm8_app/bloc/auth/auth_state.dart';
import 'package:chkm8_app/data/middleware/authentication_middleware.dart';
import 'package:chkm8_app/data/network_response_state.dart';
import 'package:chkm8_app/enum/gender_enum.dart';
import 'package:chkm8_app/models/auth_user.dart';
import 'package:chkm8_app/services/local_store_service.dart';
import 'package:chkm8_app/utils/utils.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthMiddleware _authMiddleware = AuthMiddleware();

  AuthBloc(AuthState initialState) : super(initialState);

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AuthSignupEvent) {
      yield* _mapToAuthSignupEvent(event);
    } else if (event is AuthSigninEvent) {
      yield* _mapToAuthSigninEvent(event);
    } else if (event is AuthVerifyCodeEvent) {
      yield* _mapToAuthVerifyCodeEvent(event);
    } else if (event is AuthReadyEvent) {
      yield* _mapToAuthReadyEvent(event);
    } else if (event is AuthGetMyRatingEvent) {
      yield* _mapToAuthGetMyRatingEvent(event);
    } else if (event is AuthUpdateGenderEvent) {
      yield* _mapToAuthUpdateGenderEvent(event);
    }
  }

  @override
  Future<void> close() {
    appPrint('AuthBloc closed');
    _authMiddleware.close();
    return super.close();
  }

  Stream<AuthState> _mapToAuthSignupEvent(AuthSignupEvent event) async* {
    yield AuthProcessingState();
    ResponseState signupRes = await _authMiddleware.signup(
      phone: event.phone,
      countryCode: event.countryCode,
    );

    if (signupRes is ResponseSuccessState<AuthUser>) {
      yield AuthSignupSuccessState(signupRes.responseData);
    } else if (signupRes is ResponseFailedState) {
      yield AuthSignupFailedState(failedState: signupRes);
    }
  }

  Stream<AuthState> _mapToAuthSigninEvent(AuthSigninEvent event) async* {
    yield AuthProcessingState();
    ResponseState res = await _authMiddleware.signin(
      phone: event.phone,
      countryCode: event.countryCode,
    );

    if (res is ResponseSuccessState<AuthUser>) {
      yield AuthSigninSuccessState(res.responseData);
    } else if (res is ResponseFailedState) {
      yield AuthSigninFailedState(failedState: res);
    }
  }

  Stream<AuthState> _mapToAuthVerifyCodeEvent(
      AuthVerifyCodeEvent event) async* {
    yield AuthProcessingState();
    ResponseState res = await _authMiddleware.verifyOtpCode(
      phone: event.phone,
      otpCode: event.otpCode,
    );

    if (res is ResponseSuccessState<AuthUser>) {
      AuthUser newUser = res.responseData.copyWith(phone: event.phone);
      LocalStoreService().setCurrentUser = newUser;
      var profileRes = await _authMiddleware.getMyProfile();
      if (profileRes is ResponseSuccessState<AuthUser>) {
        var rpUser = profileRes.responseData;
        var fullUser = newUser.copyWith(
          genderString: rpUser.genderString,
        );

        LocalStoreService().setCurrentUser = fullUser;
        yield AuthReadyState(fullUser);
      } else if (profileRes is ResponseFailedState) {
        yield AuthVerifyCodeFailedState(failedState: profileRes);
      }
    } else if (res is ResponseFailedState) {
      yield AuthVerifyCodeFailedState(failedState: res);
    }
  }

  Stream<AuthState> _mapToAuthReadyEvent(AuthReadyEvent event) async* {
    yield AuthReadyState(event.crUser);
    var res = await _authMiddleware.getMyRating();
    if (res is ResponseSuccessState<AuthUser>) {
      var rpUser = res.responseData;
      var fullUser = event.crUser.copyWith(
        ratingGiven: rpUser.ratingGiven,
        ratingReceived: rpUser.ratingReceived,
        integrityRating: rpUser.integrityRating,
        safetyRating: rpUser.safetyRating,
        repeatRating: rpUser.repeatRating,
      );

      LocalStoreService().setCurrentUser = fullUser;
      yield AuthReadyState(fullUser);
    } else if (res is ResponseFailedState) {}
  }

  Stream<AuthState> _mapToAuthGetMyRatingEvent(
      AuthGetMyRatingEvent event) async* {
    var crState = this.state;
    if (crState is AuthReadyState) {
      var res = await _authMiddleware.getMyRating();
      if (res is ResponseSuccessState<AuthUser>) {
        var rpUser = res.responseData;
        var fullUser = crState.crUser.copyWith(
          ratingGiven: rpUser.ratingGiven,
          ratingReceived: rpUser.ratingReceived,
          integrityRating: rpUser.integrityRating,
          safetyRating: rpUser.safetyRating,
          repeatRating: rpUser.repeatRating,
        );

        LocalStoreService().setCurrentUser = fullUser;
        yield AuthReadyState(fullUser);
      } else if (res is ResponseFailedState) {}
    }
  }

  Stream<AuthState> _mapToAuthUpdateGenderEvent(
      AuthUpdateGenderEvent event) async* {
    yield AuthProcessingState();
    var crState = this.state;
    if (crState is AuthReadyState) {
      var crUser = crState.crUser;
      var isSuccess = false;
      var limitCount = 1;
      ResponseState respo;
      while (!isSuccess && limitCount <= 3) {
        respo = await _authMiddleware.selectGender(gender: event.gender);
        if (respo is ResponseSuccessState) {
          isSuccess = true;
        } else {
          if (respo is ResponseFailedState && respo.statusCode == 500) {
            limitCount = 4;
          } else {
            limitCount += 1;
          }
        }
      }

      if (isSuccess) {
        var newUser = crUser.copyWith(genderString: event.gender.rawValue);
        LocalStoreService().setCurrentUser = newUser;
        yield AuthUpdateGenderSuccessState();
        yield AuthReadyState(newUser);
      } else {
        yield AuthUpdateGenderFailedState(failedState: respo);
        yield AuthReadyState(crUser);
      }
    }
  }
}
