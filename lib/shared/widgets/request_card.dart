import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:one_drop/core/theme/app_colors.dart';

class RequestCard
    extends
        StatelessWidget {
  final String patientName;
  final String bloodGroup;
  final String hospital;
  final String notes;
  final String units;
  final DateTime? requiredDate;
  final bool emergency;
  final String phone;
  final String email;

  const RequestCard({
    super.key,
    required this.patientName,
    required this.bloodGroup,
    required this.hospital,
    required this.notes,
    required this.units,
    required this.requiredDate,
    required this.emergency,
    required this.phone,
    required this.email,
  });

  Future<
    void
  >
  _call(
    String phone,
  ) async {
    final Uri url = Uri.parse(
      "tel:$phone",
    );
    if (!await launchUrl(
      url,
    )) {
      throw Exception(
        "Could not launch phone",
      );
    }
  }

  Future<
    void
  >
  _email(
    String email,
  ) async {
    final Uri url = Uri.parse(
      "mailto:$email",
    );
    if (!await launchUrl(
      url,
    )) {
      throw Exception(
        "Could not launch email",
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme = Theme.of(
      context,
    );

    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 12,
      ),
      padding: const EdgeInsets.all(
        16,
      ),

      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(
          18,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              .06,
            ),
            blurRadius: 12,
            offset: const Offset(
              0,
              5,
            ),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            children: [
              /// BLOOD GROUP BADGE
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(
                    8,
                  ),
                ),
                child: Text(
                  bloodGroup,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              Expanded(
                child: Text(
                  patientName,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              /// URGENT TAG
              if (emergency)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(
                      8,
                    ),
                  ),
                  child: const Text(
                    "URGENT",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(
            height: 14,
          ),

          /// HOSPITAL
          Row(
            children: [
              const Icon(
                Icons.local_hospital,
                size: 18,
                color: Colors.redAccent,
              ),
              const SizedBox(
                width: 6,
              ),
              Expanded(
                child: Text(
                  hospital,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 8,
          ),

          /// DATE
          if (requiredDate !=
              null)
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: theme.hintColor,
                ),
                const SizedBox(
                  width: 6,
                ),
                Text(
                  "${requiredDate!.day}/${requiredDate!.month}/${requiredDate!.year}",
                ),
              ],
            ),

          const SizedBox(
            height: 8,
          ),

          /// UNITS
          Row(
            children: [
              const Icon(
                Icons.bloodtype,
                size: 18,
                color: Colors.orange,
              ),
              const SizedBox(
                width: 6,
              ),
              Text(
                "Units Required: $units",
              ),
            ],
          ),

          const SizedBox(
            height: 10,
          ),

          /// NOTES
          if (notes.isNotEmpty)
            Text(
              notes,
              style: TextStyle(
                color: theme.hintColor,
              ),
            ),

          const SizedBox(
            height: 16,
          ),

          /// ACTION BUTTONS
          Row(
            children: [
              /// CALL
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _call(
                    phone,
                  ),
                  icon: const Icon(
                    Icons.call,
                  ),
                  label: const Text(
                    "Call",
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        14,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              /// EMAIL
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _email(
                    email,
                  ),
                  icon: const Icon(
                    Icons.email,
                  ),
                  label: const Text(
                    "Email",
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(
                      color: AppColors.primary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
