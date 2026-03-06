import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String phone;
  final String name;
  final String gender;

  final String? photoUrl;

  final String districtId;
  final String districtName;

  final double? lat;
  final double? lng;

  final String? bloodGroup;
  final bool isAvailable;

  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.phone,
    required this.name,
    required this.gender,
    this.photoUrl,
    required this.districtId,
    required this.districtName,
    this.lat,
    this.lng,
    this.bloodGroup,
    required this.isAvailable,
    required this.createdAt,
  });

  /// Convert model → Firestore
  Map<
    String,
    dynamic
  >
  toMap() {
    return {
      "uid": uid,
      "phone": phone,
      "name": name,
      "gender": gender,
      "photoUrl": photoUrl,
      "districtId": districtId,
      "districtName": districtName,
      "lat": lat,
      "lng": lng,
      "bloodGroup": bloodGroup,
      "isAvailable": isAvailable,
      "createdAt": Timestamp.fromDate(
        createdAt,
      ),
    };
  }

  /// Firestore → Model
  factory UserModel.fromMap(
    Map<
      String,
      dynamic
    >
    map,
    String uid,
  ) {
    return UserModel(
      uid: uid,
      phone:
          map["phone"] ??
          "",
      name:
          map["name"] ??
          "",
      gender:
          map["gender"] ??
          "",
      photoUrl: map["photoUrl"],
      districtId:
          map["districtId"] ??
          "",
      districtName:
          map["districtName"] ??
          "",
      lat:
          (map["lat"]
                  as num?)
              ?.toDouble(),
      lng:
          (map["lng"]
                  as num?)
              ?.toDouble(),
      bloodGroup: map["bloodGroup"],
      isAvailable:
          map["isAvailable"] ??
          false,
      createdAt:
          (map["createdAt"]
                  as Timestamp?)
              ?.toDate() ??
          DateTime.now(),
    );
  }

  /// Used for updating UI state (like donor availability switch)
  UserModel copyWith({
    String? uid,
    String? phone,
    String? name,
    String? gender,
    String? photoUrl,
    String? districtId,
    String? districtName,
    double? lat,
    double? lng,
    String? bloodGroup,
    bool? isAvailable,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid:
          uid ??
          this.uid,
      phone:
          phone ??
          this.phone,
      name:
          name ??
          this.name,
      gender:
          gender ??
          this.gender,
      photoUrl:
          photoUrl ??
          this.photoUrl,
      districtId:
          districtId ??
          this.districtId,
      districtName:
          districtName ??
          this.districtName,
      lat:
          lat ??
          this.lat,
      lng:
          lng ??
          this.lng,
      bloodGroup:
          bloodGroup ??
          this.bloodGroup,
      isAvailable:
          isAvailable ??
          this.isAvailable,
      createdAt:
          createdAt ??
          this.createdAt,
    );
  }
}
