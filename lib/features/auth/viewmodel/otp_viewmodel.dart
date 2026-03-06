import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../repository/user_repository.dart';

enum OtpStatus {
  initial,
  loading,
  successExistingUser,
  successNewUser,
  error,
}

class OtpViewModel extends ChangeNotifier {
  final FirebaseAuth _auth;
  final UserRepository _userRepository;

  OtpViewModel({
    FirebaseAuth? auth,
    required UserRepository userRepository,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _userRepository = userRepository;

  OtpStatus _status = OtpStatus.initial;
  OtpStatus get status => _status;

  String _enteredOtp = "";
  String get enteredOtp => _enteredOtp;

  int _secondsRemaining = 30;
  int get secondsRemaining => _secondsRemaining;

  bool _canResend = false;
  bool get canResend => _canResend;

  Timer? _timer;

  String? _verificationId;
  String? _phoneNumber;

  void initialize({
    required String phoneNumber,
    required String verificationId,
  }) {
    _phoneNumber = phoneNumber;
    _verificationId = verificationId;
    startTimer();
  }

  void _setStatus(OtpStatus status) {
    _status = status;
    notifyListeners();
  }

  void setOtp(String otp) {
    _enteredOtp = otp;
    notifyListeners();
  }

  void startTimer() {
    _canResend = false;
    _secondsRemaining = 30;
    notifyListeners();

    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
        _canResend = true;
      } else {
        _secondsRemaining--;
      }
      notifyListeners();
    });
  }

  Future<void> resendOtp() async {
    if (_phoneNumber == null) return;

    await _auth.verifyPhoneNumber(
      phoneNumber: "+91$_phoneNumber",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        debugPrint("Resend Failed: ${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        startTimer();
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> verifyOtp() async {
    if (_verificationId == null) return;

    _setStatus(OtpStatus.loading);

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _enteredOtp,
      );

      await _auth.signInWithCredential(credential);

      final uid = _auth.currentUser!.uid;

      final user = await _userRepository.getUser(uid);

      if (user != null) {
        _setStatus(OtpStatus.successExistingUser);
      } else {
        _setStatus(OtpStatus.successNewUser);
      }
    } on FirebaseAuthException catch (e) {
      debugPrint("OTP Error: ${e.message}");
      _setStatus(OtpStatus.error);
    }
  }

  void resetStatus() {
    _status = OtpStatus.initial;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}