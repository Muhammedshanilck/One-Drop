import 'package:flutter/material.dart';
import 'package:one_drop/core/theme/app_colors.dart';
import 'package:one_drop/features/donates/view/contact_details_page.dart';
import 'package:one_drop/features/donates/view/personal_details_page.dart';

class DonorFormView extends StatefulWidget {
  const DonorFormView({super.key});

  @override
  State<DonorFormView> createState() => _DonorFormViewState();
}

class _DonorFormViewState extends State<DonorFormView>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;

  /// Store form data here
  Map<String, dynamic>? personalData;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  /// Receive data from PersonalDetailsPage
  void goToContactPage(Map<String, dynamic> data) {
    setState(() {
      personalData = data;
    });

    _tabController.animateTo(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Donor Form"),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          tabs: const [
            Tab(text: "Personal Details"),
            Tab(text: "Contact Details"),
          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),

        children: [

          /// PERSONAL PAGE
          PersonalDetailsPage(
            onNext: goToContactPage,
          ),

          /// CONTACT PAGE
          personalData == null
              ? const Center(
                  child: Text("Fill personal details first"),
                )
              : ContactDetailsPage(
                  data: personalData!,
                ),
        ],
      ),
    );
  }
}