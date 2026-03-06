import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:one_drop/features/auth/view/complete_profile_view.dart';
import 'package:one_drop/features/main/view/main_view.dart';
import '../../features/auth/view/login_view.dart';
import '../../features/auth/repository/user_repository.dart';

class AuthGate
    extends
        StatelessWidget {
  const AuthGate({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return StreamBuilder<
      User?
    >(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder:
          (
            context,
            snapshot,
          ) {
            /// Loading
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            /// Not logged in
            if (!snapshot.hasData) {
              return const LoginView();
            }

            /// Logged in → check profile
            return FutureBuilder(
              future: UserRepository().getUser(
                snapshot.data!.uid,
              ),
              builder:
                  (
                    context,
                    userSnapshot,
                  ) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Scaffold(
                        body: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    /// Profile not completed
                    if (!userSnapshot.hasData) {
                      return const CompleteProfileView();
                    }

                    /// Profile completed
                    return const MainView();
                  },
            );
          },
    );
  }
}
