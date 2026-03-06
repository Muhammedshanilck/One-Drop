import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../auth/model/user_model.dart';
import '../../auth/repository/user_repository.dart';

class HomeViewModel
    extends
        ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  UserModel? _user;
  UserModel? get user => _user;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  /// Load user from Firestore
  Future<
    void
  >
  initialize() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser ==
          null)
        return;

      _user = await _userRepository.getUser(
        currentUser.uid,
      );
    } catch (
      e
    ) {
      debugPrint(
        "Home Load Error: $e",
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Toggle donor availability
  Future<
    void
  >
  toggleAvailability(
    bool value,
  ) async {
    if (_user ==
        null)
      return;

    /// 1️⃣ Update UI immediately
    _user = _user!.copyWith(
      isAvailable: value,
    );
    notifyListeners();

    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser ==
          null)
        return;

      /// 2️⃣ Update Firestore
      await _userRepository.updateAvailability(
        uid: currentUser.uid,
        isAvailable: value,
      );
    } catch (
      e
    ) {
      debugPrint(
        "Availability Update Error: $e",
      );
    }
  }
}
