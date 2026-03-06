import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:one_drop/core/theme/app_colors.dart';
import 'package:one_drop/features/auth/viewmodel/auth_viewmodel.dart';

class PersonalDetailsPage
    extends
        StatefulWidget {
  final Function(
    Map<
      String,
      dynamic
    >,
  )
  onNext;

  const PersonalDetailsPage({
    super.key,
    required this.onNext,
  });

  @override
  State<
    PersonalDetailsPage
  >
  createState() => _PersonalDetailsPageState();
}

class _PersonalDetailsPageState
    extends
        State<
          PersonalDetailsPage
        > {
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  String? _selectedGender;
  String? _selectedBlood;

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
    "A2+",
    "A2-",
    "A1B+",
    "A1B-",
    "HH",
  ];

  @override
  void initState() {
    super.initState();

    final user = context
        .read<
          AuthViewModel
        >()
        .user;

    if (user !=
        null) {
      _nameController.text =
          user.name ??
          "";
      _selectedGender = user.gender;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<
    void
  >
  _pickDate() async {
    DateTime initialDate = DateTime(
      2000,
    );

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(
        1950,
      ),
      lastDate: DateTime.now(),
    );

    if (picked !=
        null) {
      setState(
        () {
          _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
        },
      );
    }
  }

  /// VALIDATION
  void _validateAndNext() {
    if (_nameController.text.isEmpty ||
        _dobController.text.isEmpty ||
        _selectedGender ==
            null ||
        _selectedBlood ==
            null ||
        _heightController.text.isEmpty ||
        _weightController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            "Please complete all required fields before proceeding.",
          ),
        ),
      );

      return;
    }

    widget.onNext(
      {
        "name": _nameController.text,
        "dob": _dobController.text,
        "gender": _selectedGender,
        "bloodGroup": _selectedBlood,
        "height": _heightController.text,
        "weight": _weightController.text,
      },
    );
  }

  InputDecoration _inputDecoration(
    String label,
  ) {
    final isDark =
        Theme.of(
          context,
        ).brightness ==
        Brightness.dark;

    return InputDecoration(
      labelText: label,
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
          color: isDark
              ? Colors.white
              : Colors.black,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          12,
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(
        20,
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          /// NAME
          TextFormField(
            controller: _nameController,
            decoration: _inputDecoration(
              "Your Name",
            ),
          ),

          const SizedBox(
            height: 16,
          ),

          /// DOB
          TextFormField(
            controller: _dobController,
            readOnly: true,
            decoration:
                _inputDecoration(
                  "Date of Birth",
                ).copyWith(
                  suffixIcon: const Icon(
                    Icons.calendar_today,
                  ),
                ),
            onTap: _pickDate,
          ),

          const SizedBox(
            height: 20,
          ),

          /// GENDER
          const Text(
            "Gender",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          Row(
            children:
                [
                      "Male",
                      "Female",
                      "Others",
                    ]
                    .map(
                      (
                        g,
                      ) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                          ),

                          child: ChoiceChip(
                            label: Text(
                              g,
                            ),

                            selected:
                                _selectedGender ==
                                g,

                            selectedColor: AppColors.primary,

                            labelStyle: TextStyle(
                              color:
                                  _selectedGender ==
                                      g
                                  ? Colors.white
                                  : null,
                            ),

                            showCheckmark: false,

                            onSelected:
                                (
                                  _,
                                ) {
                                  setState(
                                    () {
                                      _selectedGender = g;
                                    },
                                  );
                                },
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),

          const SizedBox(
            height: 20,
          ),

          /// BLOOD GROUP
          const Text(
            "Blood Group",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          Wrap(
            spacing: 10,
            runSpacing: 10,

            children: bloodGroups.map(
              (
                b,
              ) {
                return ChoiceChip(
                  label: Text(
                    b,
                  ),

                  selected:
                      _selectedBlood ==
                      b,

                  selectedColor: AppColors.primary,

                  labelStyle: TextStyle(
                    color:
                        _selectedBlood ==
                            b
                        ? Colors.white
                        : null,
                  ),

                  showCheckmark: false,

                  onSelected:
                      (
                        _,
                      ) {
                        setState(
                          () {
                            _selectedBlood = b;
                          },
                        );
                      },
                );
              },
            ).toList(),
          ),

          const SizedBox(
            height: 20,
          ),

          /// HEIGHT
          TextFormField(
            controller: _heightController,
            keyboardType: TextInputType.number,
            decoration: _inputDecoration(
              "Height (cm)",
            ),
          ),

          const SizedBox(
            height: 16,
          ),

          /// WEIGHT
          TextFormField(
            controller: _weightController,
            keyboardType: TextInputType.number,
            decoration: _inputDecoration(
              "Weight (kg)",
            ),
          ),

          const SizedBox(
            height: 30,
          ),

          /// NEXT BUTTON
          SizedBox(
            width: double.infinity,
            height: 55,

            child: ElevatedButton(
              onPressed: _validateAndNext,

              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),

              child: const Text(
                "Next",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
