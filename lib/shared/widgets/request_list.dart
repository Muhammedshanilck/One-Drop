import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'request_card.dart';

class RequestList
    extends
        StatelessWidget {
  const RequestList({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return StreamBuilder<
      QuerySnapshot
    >(
      stream: FirebaseFirestore.instance
          .collection(
            "blood_requests",
          ) // ✅ correct collection
          .orderBy(
            "createdAt",
            descending: true,
          )
          .snapshots(),

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
                  "No requests yet",
                ),
              );
            }

            final requests = snapshot.data!.docs;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),

                const Text(
                  "Recent Blood Requests",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                ...requests.map(
                  (
                    doc,
                  ) {
                    final data =
                        doc.data()
                            as Map<
                              String,
                              dynamic
                            >;

                    return RequestCard(
                      patientName:
                          data["patientName"] ??
                          "",
                      bloodGroup:
                          data["requiredBloodGroup"] ??
                          "",
                      hospital:
                          data["hospitalName"] ??
                          "",
                      notes:
                          data["notes"] ??
                          "",
                      units:
                          data["units"] ??
                          "1",
                      requiredDate: data["requiredDate"]?.toDate(),
                      emergency:
                          data["emergency"] ??
                          false,
                      phone:
                          data["phone"] ??
                          "",
                      email:
                          data["email"] ??
                          "",
                    );
                  },
                ).toList(),
              ],
            );
          },
    );
  }
}
