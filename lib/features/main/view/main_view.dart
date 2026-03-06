import 'package:flutter/material.dart';
import 'package:one_drop/features/profile/view/profile_view.dart';
import 'package:one_drop/features/requests/view/request_view.dart';
import 'package:one_drop/features/donates/view/donates_view.dart';
import 'package:provider/provider.dart';
import 'package:one_drop/core/theme/app_colors.dart';
import '../../home/view/home_view.dart';
import '../viewmodel/main_viewmodel.dart';

class MainView
    extends
        StatelessWidget {
  const MainView({
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
          ) => MainViewModel(),
      child: const _MainBody(),
    );
  }
}

class _MainBody
    extends
        StatelessWidget {
  const _MainBody();

  @override
  Widget build(
    BuildContext context,
  ) {
    final vm = context
        .watch<
          MainViewModel
        >();

    final screens = [
      const HomeView(),
      const DonatesView(),
      const RequestView(),
      const ProfileView(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: vm.currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: vm.currentIndex,
        onTap: vm.changeTab,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.bloodtype_outlined,
            ),
            label: "Donates",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.handshake_outlined,
            ),
            label: "Requests",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
