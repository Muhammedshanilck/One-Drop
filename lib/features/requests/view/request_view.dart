import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:one_drop/core/theme/app_colors.dart';
import 'package:one_drop/features/main/view/main_view.dart';

class RequestView
    extends
        StatefulWidget {
  const RequestView({
    super.key,
  });

  @override
  State<
    RequestView
  >
  createState() => _RequestViewState();
}

class _RequestViewState
    extends
        State<
          RequestView
        > {
  final _formKey =
      GlobalKey<
        FormState
      >();

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final hospitalController = TextEditingController();
  final unitsController = TextEditingController();
  final notesController = TextEditingController();

  String? gender;
  String? patientBloodGroup;
  String? requiredBloodGroup;

  bool emergency = false;
  DateTime? requiredDate;

  final List<
    String
  >
  bloodGroups = [
    "A+",
    "A-",
    "B+",
    "B-",
    "AB+",
    "AB-",
    "O+",
    "O-",
    "A1+",
    "A1-",
    "A1B+",
    "A1B-",
    "A2+",
    "A2-",
    "A2B+",
    "A2B-",
    "HH",
  ];

  /// FIELD DECORATION
  InputDecoration fieldDecoration(
    String hint, {
    IconData? icon,
  }) {
    final theme = Theme.of(
      context,
    );

    return InputDecoration(
      hintText: hint,
      prefixIcon:
          icon !=
              null
          ? Icon(
              icon,
            )
          : null,
      filled: true,
      fillColor: theme.cardColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          12,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          12,
        ),
        borderSide: BorderSide(
          color: theme.dividerColor,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          12,
        ),
        borderSide: BorderSide(
          color: theme.colorScheme.primary,
          width: 2,
        ),
      ),
    );
  }

  /// DATE PICKER
  Future pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(
        2100,
      ),
    );

    if (picked !=
        null) {
      setState(
        () {
          requiredDate = picked;
        },
      );
    }
  }

  /// FIREBASE SUBMIT
  Future submitRequest() async {
    if (!_formKey.currentState!.validate()) return;

    if (gender ==
            null ||
        patientBloodGroup ==
            null ||
        requiredBloodGroup ==
            null ||
        requiredDate ==
            null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            "Please complete all required fields",
          ),
        ),
      );
      return;
    }

    await FirebaseFirestore.instance
        .collection(
          "blood_requests",
        )
        .add(
          {
            "patientName": nameController.text.trim(),
            "age": ageController.text.trim(),
            "hospitalName": hospitalController.text.trim(),
            "gender": gender,
            "patientBloodGroup": patientBloodGroup,
            "requiredBloodGroup": requiredBloodGroup,
            "units": unitsController.text.trim(),
            "emergency": emergency,
            "requiredDate": requiredDate,
            "notes": notesController.text.trim(),
            "createdAt": Timestamp.now(),
          },
        );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      const SnackBar(
        content: Text(
          "Request submitted successfully",
        ),
      ),
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder:
            (
              context,
            ) => const MainView(),
      ),
      (
        route,
      ) => false,
    );
  }

  /// CHIP STYLE
  Widget chip(
    String value,
    String? selected,
    Function(
      String,
    )
    onTap,
  ) {
    final theme = Theme.of(
      context,
    );

    return ChoiceChip(
      label: Text(
        value,
      ),
      selected:
          selected ==
          value,
      onSelected:
          (
            _,
          ) {
            setState(
              () {
                onTap(
                  value,
                );
              },
            );
          },
      selectedColor: theme.colorScheme.primary,
      backgroundColor: theme.cardColor,
      labelStyle: TextStyle(
        color:
            selected ==
                value
            ? Colors.white
            : theme.textTheme.bodyMedium!.color,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          10,
        ),
        side: BorderSide(
          color:
              selected ==
                  value
              ? theme.colorScheme.primary
              : theme.dividerColor,
        ),
      ),
    );
  }

  /// BLOOD GROUP SELECTOR
  Widget bloodSelector(
    String title,
    String? selected,
    Function(
      String,
    )
    onSelect,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle(
          title,
        ),
        const SizedBox(
          height: 10,
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: bloodGroups
              .map(
                (
                  e,
                ) => chip(
                  e,
                  selected,
                  onSelect,
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  /// GENDER
  Widget genderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle(
          "Gender",
        ),
        const SizedBox(
          height: 10,
        ),
        Wrap(
          spacing: 10,
          children: [
            chip(
              "Male",
              gender,
              (
                v,
              ) => gender = v,
            ),
            chip(
              "Female",
              gender,
              (
                v,
              ) => gender = v,
            ),
            chip(
              "Other",
              gender,
              (
                v,
              ) => gender = v,
            ),
          ],
        ),
      ],
    );
  }

  /// SECTION TITLE
  Widget sectionTitle(
    String text,
  ) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// DATE FIELD
  Widget dateField() {
    final theme = Theme.of(
      context,
    );

    return GestureDetector(
      onTap: pickDate,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(
            12,
          ),
          border: Border.all(
            color: theme.dividerColor,
          ),
        ),
        child: Text(
          requiredDate ==
                  null
              ? "Select required date"
              : requiredDate.toString().split(
                  " ",
                )[0],
        ),
      ),
    );
  }

  /// INFO CARD
  Widget infoCard() {
    return Container(
      padding: const EdgeInsets.all(
        14,
      ),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(
          .08,
        ),
        borderRadius: BorderRadius.circular(
          12,
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.red,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              "Provide patient details to create a blood request.",
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme = Theme.of(
      context,
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.primary,
        title: const Text(
          "New Request",
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
          16,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /// INFO CARD
              infoCard(),
              const SizedBox(
                height: 20,
              ),

              TextFormField(
                controller: nameController,
                decoration: fieldDecoration(
                  "Enter patient's full name",
                  icon: Icons.person,
                ),
                validator:
                    (
                      v,
                    ) => v!.isEmpty
                    ? "Enter patient name"
                    : null,
              ),

              const SizedBox(
                height: 16,
              ),

              TextFormField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: fieldDecoration(
                  "Enter age",
                  icon: Icons.cake,
                ),
                validator:
                    (
                      v,
                    ) => v!.isEmpty
                    ? "Enter age"
                    : null,
              ),

              const SizedBox(
                height: 16,
              ),

              TextFormField(
                controller: hospitalController,
                decoration: fieldDecoration(
                  "Hospital / Trust Name",
                  icon: Icons.local_hospital,
                ),
                validator:
                    (
                      v,
                    ) => v!.isEmpty
                    ? "Enter hospital name"
                    : null,
              ),

              const SizedBox(
                height: 24,
              ),

              genderSelector(),

              const SizedBox(
                height: 24,
              ),

              bloodSelector(
                "Patient Blood Group",
                patientBloodGroup,
                (
                  v,
                ) => patientBloodGroup = v,
              ),

              const SizedBox(
                height: 24,
              ),

              bloodSelector(
                "Required Blood Group",
                requiredBloodGroup,
                (
                  v,
                ) => requiredBloodGroup = v,
              ),

              const SizedBox(
                height: 24,
              ),

              TextFormField(
                controller: unitsController,
                keyboardType: TextInputType.number,
                decoration: fieldDecoration(
                  "Number of units required",
                  icon: Icons.opacity,
                ),
                validator:
                    (
                      v,
                    ) => v!.isEmpty
                    ? "Enter units"
                    : null,
              ),

              const SizedBox(
                height: 20,
              ),

              /// EMERGENCY
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                  color: emergency
                      ? Colors.red.withOpacity(
                          .1,
                        )
                      : Colors.transparent,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Emergency Request",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Switch(
                      value: emergency,
                      activeColor: Colors.red,
                      onChanged:
                          (
                            v,
                          ) {
                            setState(
                              () {
                                emergency = v;
                              },
                            );
                          },
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              dateField(),

              const SizedBox(
                height: 20,
              ),

              TextFormField(
                controller: notesController,
                maxLines: 3,
                decoration: fieldDecoration(
                  "Additional notes",
                  icon: Icons.notes,
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: submitRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        12,
                      ),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    "Submit Request",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
