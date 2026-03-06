import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:one_drop/features/auth/model/user_model.dart';

enum AuthStatus {
  idle,
  sendingOtp,
  otpSent,
  error,
}

class AuthViewModel
    extends
        ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthStatus _status = AuthStatus.idle;
  AuthStatus get status => _status;

  bool get isLoading =>
      _status ==
      AuthStatus.sendingOtp;

  String? _verificationId;
  String? get verificationId => _verificationId;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  UserModel? _user;
  UserModel? get user => _user;

  void _setStatus(
    AuthStatus value,
  ) {
    _status = value;
    notifyListeners();
  }

  /// SEND OTP
  Future<
    void
  >
  sendOtp(
    String phone,
  ) async {
    try {
      _errorMessage = null;
      _setStatus(
        AuthStatus.sendingOtp,
      );

      await _auth.verifyPhoneNumber(
        phoneNumber: "+91$phone",
        timeout: const Duration(
          seconds: 60,
        ),

        verificationCompleted:
            (
              PhoneAuthCredential credential,
            ) async {
              await _auth.signInWithCredential(
                credential,
              );
            },

        verificationFailed:
            (
              FirebaseAuthException e,
            ) {
              debugPrint(
                "Verification Failed: ${e.message}",
              );
              _errorMessage =
                  e.message ??
                  "OTP verification failed";
              _setStatus(
                AuthStatus.error,
              );
            },

        codeSent:
            (
              String verificationId,
              int? resendToken,
            ) {
              _verificationId = verificationId;
              _setStatus(
                AuthStatus.otpSent,
              );
            },

        codeAutoRetrievalTimeout:
            (
              String verificationId,
            ) {
              _verificationId = verificationId;
            },
      );
    } catch (
      e
    ) {
      debugPrint(
        "Error sending OTP: $e",
      );
      _errorMessage = "Something went wrong. Try again.";
      _setStatus(
        AuthStatus.error,
      );
    }
  }

  /// RESET STATUS
  void resetStatus() {
    _status = AuthStatus.idle;
    notifyListeners();
  }

  /// LOAD USER FROM FIRESTORE
  Future<
    void
  >
  loadUser() async {
    try {
      final firebaseUser = _auth.currentUser;

      if (firebaseUser ==
          null)
        return;

      final doc = await _firestore
          .collection(
            "users",
          )
          .doc(
            firebaseUser.uid,
          )
          .get();

      if (doc.exists &&
          doc.data() !=
              null) {
        _user = UserModel.fromMap(
          doc.data()!,
          doc.id,
        );
        notifyListeners();
      }
    } catch (
      e
    ) {
      debugPrint(
        "Load user error: $e",
      );
    }
  }

  /// LOGOUT
  Future<
    void
  >
  logout(
    BuildContext context,
  ) async {
    try {
      await _auth.signOut();

      _user = null;
      notifyListeners();

      /// Navigate to login and clear stack
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(
        "/login",
        (
          route,
        ) => false,
      );
    } catch (
      e
    ) {
      debugPrint(
        "Logout error: $e",
      );
    }
  }

  /// DELETE ACCOUNT
  Future<
    void
  >
  deleteAccount(
    BuildContext context,
  ) async {
    try {
      final currentUser = _auth.currentUser;

      if (currentUser ==
          null)
        return;

      /// delete firestore user
      await _firestore
          .collection(
            "users",
          )
          .doc(
            currentUser.uid,
          )
          .delete();

      /// delete firebase auth account
      await currentUser.delete();

      /// sign out
      await _auth.signOut();

      _user = null;
      notifyListeners();

      /// Navigate to login screen
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(
        "login",
        (
          route,
        ) => false,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            "Account deleted successfully",
          ),
        ),
      );
    } catch (
      e
    ) {
      debugPrint(
        "Delete account error: $e",
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to delete account",
          ),
        ),
      );
    }
  }
}
