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

    if (await canLaunchUrl(
      url,
    )) {
      await launchUrl(
        url,
      );
    }
  }

  Future<
    void
  >
  _mail(
    String email,
  ) async {
    final Uri url = Uri.parse(
      "mailto:$email",
    );

    if (await canLaunchUrl(
      url,
    )) {
      await launchUrl(
        url,
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return StreamBuilder<
      QuerySnapshot
    >(
      stream: FirebaseFirestore.instance
          .collection(
            "donors",
          )
          .orderBy(
            "createdAt",
            descending: true,
          )
          .snapshots(), // 🔥 REALTIME LISTENER
      builder:
          (
            context,
            snapshot,
          ) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

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
              padding: const EdgeInsets.all(
                16,
              ),
              itemCount: donors.length,
              itemBuilder:
                  (
                    context,
                    index,
                  ) {
                    final data = donors[index];

                    final name =
                        data["name"] ??
                        "";
                    final phone =
                        data["phone"] ??
                        "";
                    final email =
                        data["email"] ??
                        "";
                    final blood =
                        data["bloodGroup"] ??
                        "";
                    final city =
                        data["city"] ??
                        "";

                    return Container(
                      margin: const EdgeInsets.only(
                        bottom: 14,
                      ),
                      padding: const EdgeInsets.all(
                        16,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).cardColor,
                        borderRadius: BorderRadius.circular(
                          16,
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black.withOpacity(
                              .05,
                            ),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Name + blood group
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(
                                    20,
                                  ),
                                ),
                                child: Text(
                                  blood,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 6,
                          ),

                          Text(
                            city,
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(
                            height: 12,
                          ),

                          Row(
                            children: [
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
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => _mail(
                                    email,
                                  ),
                                  icon: const Icon(
                                    Icons.email,
                                  ),
                                  label: const Text(
                                    "Email",
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
    );
  }
}
