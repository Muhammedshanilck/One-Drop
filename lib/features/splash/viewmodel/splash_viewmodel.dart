import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:one_drop/core/routing/app_router.dart';
import 'package:one_drop/features/auth/repository/user_repository.dart';

class SplashViewModel
    extends
        ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserRepository _userRepository = UserRepository();

  Future<
    void
  >
  initialize(
    BuildContext context,
  ) async {
    await Future.delayed(
      const Duration(
        seconds: 2,
      ),
    );

    final user = _auth.currentUser;

    /// 1️⃣ Not logged in
    if (user ==
        null) {
      if (context.mounted) {
        Navigator.pushReplacementNamed(
          context,
          AppRouter.login,
        );
      }
      return;
    }

    /// 2️⃣ Check profile
    final userData = await _userRepository.getUser(
      user.uid,
    );

    /// 3️⃣ Profile not completed
    if (userData ==
        null) {
      if (context.mounted) {
        Navigator.pushReplacementNamed(
          context,
          AppRouter.completeProfile,
        );
      }
      return;
    }

    /// 4️⃣ Logged in + profile completed
    if (context.mounted) {
      Navigator.pushReplacementNamed(
        context,
        AppRouter.main,
      );
    }
  }
}
