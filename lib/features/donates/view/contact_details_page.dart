import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:one_drop/core/theme/app_colors.dart';
import 'package:one_drop/core/service/location_service.dart';
import 'package:one_drop/core/models/place_model.dart';

class ContactDetailsPage
    extends
        StatefulWidget {
  final Map<
    String,
    dynamic
  >
  data;

  const ContactDetailsPage({
    super.key,
    required this.data,
  });

  @override
  State<
    ContactDetailsPage
  >
  createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState
    extends
        State<
          ContactDetailsPage
        > {
  final emailController = TextEditingController();
  final cityController = TextEditingController();
  final phoneController = TextEditingController();

  List<
    PlaceModel
  >
  suggestions = [];

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;

    if (user !=
            null &&
        user.phoneNumber !=
            null) {
      phoneController.text = user.phoneNumber!;
    }
  }

  /// SEARCH CITY USING GOOGLE API
  Future<
    void
  >
  searchCity(
    String query,
  ) async {
    if (query.isEmpty) {
      setState(
        () {
          suggestions = [];
        },
      );
      return;
    }

    final results = await LocationService().searchPlaces(
      query,
    );

    setState(
      () {
        suggestions = results;
      },
    );
  }

  Future<
    void
  >
  saveDonor() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection(
          "users",
        )
        .doc(
          uid,
        )
        .update(
          {
            "name": widget.data["name"],
            "gender": widget.data["gender"],
            "bloodGroup": widget.data["bloodGroup"],
            "email": emailController.text.trim(),
            "districtName": cityController.text.trim(),
            "phone": phoneController.text.trim(),
            "isAvailable": true,
          },
        );

    if (!mounted) return;

    Navigator.popUntil(
      context,
      (
        route,
      ) => route.isFirst,
    );
  }

  InputDecoration fieldDecoration(
    String label,
  ) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          10,
        ),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 2,
        ),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Contact Details",
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
          20,
        ),
        child: Column(
          children: [
            /// EMAIL
            TextField(
              controller: emailController,
              decoration: fieldDecoration(
                "Email",
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            /// PHONE
            TextField(
              controller: phoneController,
              readOnly: true,
              decoration: fieldDecoration(
                "Phone",
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            /// CITY SEARCH
            TextField(
              controller: cityController,
              decoration: fieldDecoration(
                "City",
              ),
              onChanged: searchCity,
            ),

            /// SUGGESTIONS DROPDOWN
            if (suggestions.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(
                  top: 8,
                ),
                constraints: const BoxConstraints(
                  maxHeight: 200,
                ),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: suggestions.length,
                  itemBuilder:
                      (
                        context,
                        index,
                      ) {
                        final place = suggestions[index];

                        return ListTile(
                          leading: const Icon(
                            Icons.location_on,
                          ),
                          title: Text(
                            place.name,
                          ),
                          onTap: () {
                            cityController.text = place.name;

                            setState(
                              () {
                                suggestions = [];
                              },
                            );

                            FocusScope.of(
                              context,
                            ).unfocus();
                          },
                        );
                      },
                ),
              ),

            const SizedBox(
              height: 30,
            ),

            /// SUBMIT BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: saveDonor,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  "Submit",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
