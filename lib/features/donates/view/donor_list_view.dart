import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:one_drop/core/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class DonorListView
    extends
        StatelessWidget {
  const DonorListView({
    super.key,
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

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primary,
        title: const Text(
          "Available Donors",
        ),
      ),

      body:
          StreamBuilder<
            QuerySnapshot
          >(
            stream: FirebaseFirestore.instance
                .collection(
                  "users",
                )
                .where(
                  "bloodGroup",
                  isNull: false,
                )
                .snapshots(),

            builder:
                (
                  context,
                  snapshot,
                ) {
                  /// Loading
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  /// Error
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        "Something went wrong",
                      ),
                    );
                  }

                  /// Empty
                  if (!snapshot.hasData ||
                      snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No donors available",
                      ),
                    );
                  }

                  final donors = snapshot.data!.docs;

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    itemCount: donors.length,
                    itemBuilder:
                        (
                          context,
                          index,
                        ) {
                          final donor = donors[index];

                          final name =
                              donor["name"] ??
                              "Unknown";
                          final bloodGroup =
                              donor["bloodGroup"] ??
                              "--";
                          final city =
                              donor["districtName"] ??
                              "";
                          final phone =
                              donor["phone"] ??
                              "Not available";
                          final email =
                              donor["email"] ??
                              "Not available";

                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            padding: const EdgeInsets.all(
                              16,
                            ),

                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(
                                16,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(
                                    .08,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(
                                    0,
                                    4,
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
                                    /// Avatar
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundColor: Colors.grey,
                                      child: Text(
                                        name.isNotEmpty
                                            ? name[0].toUpperCase()
                                            : "?",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(
                                      width: 12,
                                    ),

                                    /// Name + Location
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),

                                          const SizedBox(
                                            height: 4,
                                          ),

                                          Row(
                                            children: [
                                              Icon(
                                                Icons.location_on,
                                                size: 16,
                                                color: Colors.green,
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                city,
                                                style: TextStyle(
                                                  color: theme.hintColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

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
                                  ],
                                ),

                                const SizedBox(
                                  height: 14,
                                ),

                                /// PHONE
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.phone,
                                      size: 18,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Expanded(
                                      child: Text(
                                        "Phone: $phone",
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                  height: 6,
                                ),

                                /// EMAIL
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.email,
                                      size: 18,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Expanded(
                                      child: Text(
                                        "Email: $email",
                                      ),
                                    ),
                                  ],
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
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(
                                      width: 10,
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
                                          side: const BorderSide(
                                            color: AppColors.primary,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
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
                        },
                  );
                },
          ),
    );
  }
}
