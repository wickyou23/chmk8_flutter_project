enum NWErrorEnum {
  phoneInvalidError,
  phoneSMSFailedError,
  phoneOTPFailedError,
  phoneExistsError,
  phoneNotExistsError,
  sharedCodeInvalid,
  sharedCodeExpired,
}

extension NWErrorEnumExt on NWErrorEnum {
  static NWErrorEnum initRawValue(int rawValue) {
    switch (rawValue) {
      case 2000:
        return NWErrorEnum.phoneInvalidError;
      case 2001:
        return NWErrorEnum.phoneSMSFailedError;
      case 2002:
        return NWErrorEnum.phoneOTPFailedError;
      case 2003:
        return NWErrorEnum.phoneExistsError;
      case 2004:
        return NWErrorEnum.phoneNotExistsError;
      case 2014:
        return NWErrorEnum.sharedCodeInvalid;
      case 2016:
        return NWErrorEnum.sharedCodeExpired;
      default:
        return null;
    }
  }

  String get errorMessage {
    switch (this) {
      case NWErrorEnum.phoneInvalidError:
        return 'Phone invalid';
      case NWErrorEnum.phoneSMSFailedError:
        return 'SMS failed';
      case NWErrorEnum.phoneOTPFailedError:
        return 'OTP failed';
      case NWErrorEnum.phoneExistsError:
        return 'Phone exists';
      case NWErrorEnum.phoneNotExistsError:
        return 'Phone not exists';
      case NWErrorEnum.phoneNotExistsError:
        return 'Shared code not exists';
      case NWErrorEnum.sharedCodeInvalid:
        return 'The code entered is invalid. Please check your code and try again.';
      case NWErrorEnum.sharedCodeExpired:
        return 'The code you entered has expired. Please enter a new code or go to Home to create your own invitation.';
      default:
        return '';
    }
  }
}
