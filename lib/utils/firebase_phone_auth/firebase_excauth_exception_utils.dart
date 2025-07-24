import 'package:firebase_auth/firebase_auth.dart';

import '../../main.dart';

class FirebaseAuthHandleExceptionsUtils {
  String handleException(FirebaseAuthException firebaseAuthException) {
    String message = '';
    switch (firebaseAuthException.code) {
      case 'network-request-failed':
        message = locale.value.pleaseCheckYourMobileInternetConnection;
        break;
      case 'invalid-verification-code':
        message = locale.value.pleaseEnterAValidCode;
        break;
      case 'too-many-requests':
        message = locale.value.pleaseTryAgainAfterSomeTime;
        break;
      case 'invalid-phone-number':
        message = locale.value.pleaseEnterAValidMobileNo;
        break;
      default:
        message = firebaseAuthException.message!;
    }
    return message;
  }
}