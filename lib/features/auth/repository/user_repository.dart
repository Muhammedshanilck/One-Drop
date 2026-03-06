import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository({
    FirebaseFirestore? firestore,
  }) : _firestore =
           firestore ??
           FirebaseFirestore.instance;

  final String _collection = "users";

  Future<
    UserModel?
  >
  getUser(
    String uid,
  ) async {
    try {
      final doc = await _firestore
          .collection(
            _collection,
          )
          .doc(
            uid,
          )
          .get();

      if (!doc.exists) return null;

      return UserModel.fromMap(
        doc.data()!,
        uid,
      );
    } catch (
      e
    ) {
      throw Exception(
        "Failed to fetch user: $e",
      );
    }
  }

  Future<
    void
  >
  createUser(
    UserModel user,
  ) async {
    try {
      await _firestore
          .collection(
            _collection,
          )
          .doc(
            user.uid,
          )
          .set(
            user.toMap(),
          );
    } catch (
      e
    ) {
      throw Exception(
        "Failed to create user: $e",
      );
    }
  }

  Future<
    void
  >
  updateAvailability({
    required String uid,
    required bool isAvailable,
  }) async {
    try {
      await _firestore
          .collection(
            _collection,
          )
          .doc(
            uid,
          )
          .update(
            {
              "isAvailable": isAvailable,
            },
          );
    } catch (
      e
    ) {
      throw Exception(
        "Failed to update availability: $e",
      );
    }
  }
}
