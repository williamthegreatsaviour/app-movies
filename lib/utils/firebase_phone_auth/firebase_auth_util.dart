// ignore_for_file: prefer_function_declarations_over_variables

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../main.dart';
import 'firebase_excauth_exception_utils.dart';

class FirebaseAuthUtil {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static User? get currentUser {
    return firebaseAuth.currentUser;
  }

  Future<void> login({required String mobileNumber, required ValueChanged<String> onCodeSent, required ValueChanged<FirebaseAuthException> onVerificationFailed}) async {
    final PhoneVerificationCompleted verificationCompleted = (AuthCredential phoneAuthCredential) {};

    final PhoneVerificationFailed verificationFailed = (FirebaseAuthException authException) {
      onVerificationFailed(authException);
    };
    final PhoneCodeSent codeSent = (String verificationId, [int? forceResendingToken]) {
      onCodeSent(verificationId);
    };
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout = (String verificationId) {};
    return firebaseAuth.verifyPhoneNumber(
      phoneNumber: '+$mobileNumber',
      timeout: const Duration(seconds: 20),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future<void> verifyOTPCode(
      {required String verificationId, required String verificationCode, required ValueChanged<User> onVerificationSuccess, required ValueChanged<String> onCodeVerificationFailed}) async {
    AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: verificationCode);
    log("Verification ==> $verificationCode & $verificationId");
    await firebaseAuth.signInWithCredential(credential).then((value) {
      if (value.user != null) {
        onVerificationSuccess(value.user!);
      } else {
        onCodeVerificationFailed(locale.value.verificationFailed);
      }
    }).catchError((error) {
      onCodeVerificationFailed(FirebaseAuthHandleExceptionsUtils()
          .handleException(
            FirebaseAuthException(code: error.toString().contains("firebase_auth/invalid-verification-code") ? "invalid-verification-code" : error.toString(), message: error.toString()),
          )
          .toString());
    });
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  static String? get phoneNumberWithPlusSymbol {
    return FirebaseAuth.instance.currentUser?.phoneNumber;
  }
}
