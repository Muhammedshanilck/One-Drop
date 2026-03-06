import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:one_drop/core/service/location_service.dart';
import '../../../core/models/place_model.dart';
import '../../auth/model/user_model.dart';
import '../../auth/repository/user_repository.dart';

class CompleteProfileViewModel
    extends
        ChangeNotifier {
  final UserRepository _userRepository;
  final LocationService _locationService;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CompleteProfileViewModel(
    this._userRepository,
    this._locationService,
  );

  // ---------------- Controllers ----------------

  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  // ---------------- State ----------------

  String? _selectedGender;
  String? get selectedGender => _selectedGender;

  String? _selectedPlaceId;
  String? get selectedPlaceId => _selectedPlaceId;

  String? _selectedPlaceName;
  String? get selectedPlaceName => _selectedPlaceName;

  double? _lat;
  double? _lng;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<
    PlaceModel
  >
  _searchResults = [];
  List<
    PlaceModel
  >
  get searchResults => _searchResults;

  Timer? _debounce;

  // ---------------- Gender ----------------

  void setGender(
    String gender,
  ) {
    _selectedGender = gender;
    notifyListeners();
  }

  // ---------------- SEARCH ----------------

  Future<
    void
  >
  onSearchChanged(
    String query,
  ) async {
    print(
      "USER TYPED: $query",
    );

    // Cancel previous timer
    if (_debounce?.isActive ??
        false) {
      _debounce!.cancel();
    }

    // Start debounce timer
    _debounce = Timer(
      const Duration(
        milliseconds: 400,
      ),
      () {
        _performSearch(
          query,
        );
      },
    );
  }

  // ---------------- GOOGLE API CALL ----------------

  Future<
    void
  >
  _performSearch(
    String query,
  ) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    try {
      print(
        "CALLING GOOGLE API...",
      );

      final results = await _locationService.searchPlaces(
        query,
      );

      print(
        "RESULT COUNT: ${results.length}",
      );

      _searchResults = results;

      notifyListeners();
    } catch (
      e
    ) {
      debugPrint(
        "Place search error: $e",
      );

      _searchResults = [];
      notifyListeners();
    }
  }

  // ---------------- SELECT PLACE ----------------

  Future<
    void
  >
  selectPlace(
    PlaceModel place,
  ) async {
    _selectedPlaceId = place.id;
    _selectedPlaceName = place.name;

    locationController.text = place.name;

    try {
      final location = await _locationService.getPlaceDetails(
        place.id,
      );

      _lat = location["lat"];
      _lng = location["lng"];
    } catch (
      e
    ) {
      debugPrint(
        "Place detail error: $e",
      );
    }

    _searchResults.clear();

    notifyListeners();
  }

  // ---------------- FORM VALIDATION ----------------

  bool get isFormValid {
    return nameController.text.trim().isNotEmpty &&
        _selectedGender !=
            null &&
        _selectedPlaceId !=
            null;
  }

  void _setLoading(
    bool value,
  ) {
    _isLoading = value;
    notifyListeners();
  }

  // ---------------- SAVE PROFILE ----------------

  Future<
    bool
  >
  saveProfile() async {
    if (!isFormValid) return false;

    _setLoading(
      true,
    );

    try {
      final user = _auth.currentUser;

      if (user ==
          null)
        return false;

      final newUser = UserModel(
        uid: user.uid,
        phone:
            user.phoneNumber ??
            "",
        name: nameController.text.trim(),
        gender: _selectedGender!,
        districtId: _selectedPlaceId!,
        districtName: _selectedPlaceName!,
        lat: _lat,
        lng: _lng,
        bloodGroup: null,
        isAvailable: false,
        createdAt: DateTime.now(),
      );

      await _userRepository.createUser(
        newUser,
      );

      return true;
    } catch (
      e
    ) {
      debugPrint(
        "Profile Save Error: $e",
      );

      return false;
    } finally {
      _setLoading(
        false,
      );
    }
  }

  // ---------------- CLEANUP ----------------

  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}
