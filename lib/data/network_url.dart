import 'package:chkm8_app/app_config.dart';

class NetworkUrl {
  static const _baseProductionURL = 'https://chkm8.leanstartlab.io';
  static const _baseStagingURL = 'http://113.161.185.38:8080';
  static String get baseURL {
    return AppConfig.enviroment == AppEnvironment.production
        ? _baseProductionURL
        : _baseStagingURL;
  }

  //AUTH
  static const signinURL = '/api/mobile/auth/sendOtp';
  static const signupURL = '/api/mobile/auth/sendOtp';
  static const verityCodeURL = '/api/mobile/auth/verifyOtp';

  //FIRST MEETING
  static const getMySafetySharedCodeURL = '/api/mobile/rating/share';
  static const acceptSafetyCodeURL = '/api/mobile/rating/share';
  static const validateCodeURL = '/api/mobile/rating/validate-code';
  static const cancelInvitationURL = '/api/mobile/rating/share/cancel';

  //BEFORE MEETING
  static const getMyScheduleMutualCodeURL = '/api/mobile/rating/schedule';
  static const getScheduleRemindRatingURL = '/api/mobile/rating/time';
  static const checkScheduleRated = '/api/mobile/rating/status';

  //AFTER MEETING
  static const ratingURL = '/api/mobile/rating/rate';
  static const pendingRateURL = '/api/mobile/rating/rate/pending';
  static const givenRateURL = '/api/mobile/rating/rate/given';

  //OTHERS
  static const submitNotificationTokenURL = '/api/notification/token';
  static const myRatingURL = '/api/mobile/rating/me';
  static const notificationListURL = '/api/notification';
  static const ratingLastestAcceptURL = '/api/mobile/rating/latest-log';
  static const updateProfileURL = '/api/mobile/account/profile';
  static const myProfileURL = '/api/mobile/account/profile';
}
