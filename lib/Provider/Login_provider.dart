import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OtpProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? _verificationId;
  String _status = '';

  String get status => _status;

  Future<void> sendOtp(String phoneNumber) async {
    _status = 'Sending OTP...';
    notifyListeners();

    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        _status = 'OTP Sent';
        notifyListeners();
      },
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _firebaseAuth.signInWithCredential(credential);
        _status = 'Phone number automatically verified and user signed in: ${credential.providerId}';
        notifyListeners();
      },
      verificationFailed: (FirebaseAuthException e) {
        _status = 'Failed to verify phone number: ${e.message}';
        notifyListeners();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  Future<void> verifyOtp(String otp) async {
    _status = 'Verifying OTP...';
    notifyListeners();

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      await _firebaseAuth.signInWithCredential(credential);
      _status = 'Phone number verified and user signed in';
    } catch (e) {
      _status = 'Failed to sign in: ${e.toString()}';
    }

    notifyListeners();
  }
}
