import 'package:flutter/material.dart';
import 'package:one_drop/shared/widgets/request_list.dart';
import 'package:one_drop/shared/widgets/top_curve_clipper.dart';
import 'package:provider/provider.dart';
import '../viewmodel/home_viewmodel.dart';
import '../widgets/home_header.dart';
import '../widgets/stats_row.dart';
import '../widgets/emergency_button.dart';
import '../widgets/search_donor_button.dart';
import '../widgets/donor_status_card.dart';
import 'package:one_drop/core/theme/app_colors.dart';

class HomeView
    extends
        StatelessWidget {
  const HomeView({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return ChangeNotifierProvider(
      create:
          (
            _,
          ) => HomeViewModel()..initialize(),
      child: const _HomeBody(),
    );
  }
}

class _HomeBody
    extends
        StatelessWidget {
  const _HomeBody();

  @override
  Widget build(
    BuildContext context,
  ) {
    final vm = context
        .watch<
          HomeViewModel
        >();

    if (vm.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      );
    }

    final user = vm.user;

    return Scaffold(
      body: Stack(
        children: [
          ClipPath(
            clipper: TopCurveClipper(),
            child: Container(
              height: 250,
              width: double.infinity,
              color: AppColors.primary.withOpacity(
                0.2,
              ),
            ),
          ),

          /// Main Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),

                  /// Header on top of curve
                  HomeHeader(
                    user: user,
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  const StatsRow(),

                  const SizedBox(
                    height: 30,
                  ),

                  DonorStatusCard(
                    user: user,
                    onToggle: vm.toggleAvailability,
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  const RequestList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
