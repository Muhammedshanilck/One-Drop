import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:one_drop/features/splash/viewmodel/splash_viewmodel.dart';

class SplashView
    extends
        StatefulWidget {
  const SplashView({
    super.key,
  });

  @override
  State<
    SplashView
  >
  createState() => _SplashViewState();
}

class _SplashViewState
    extends
        State<
          SplashView
        > {
  @override
  void initState() {
    super.initState();

    Future.microtask(
      () {
        context
            .read<
              SplashViewModel
            >()
            .initialize(
              context,
            );
      },
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image(
            //   image: AssetImage(
            //     'assets/icons/app_icon.png',
            //   ),
            //   width: 300,
            //   height: 300,
            // ),
            // SizedBox(
            //   height: 20,
            // ),
            // Text(
            //   'One Drop',
            //   style: TextStyle(
            //     fontSize: 26,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.black,
            //   ),
            // ),
            // SizedBox(
            //   height: 6,
            // ),
            // Text(
            //   'Save Lives',
            //   style: TextStyle(
            //     fontSize: 14,
            //     color: Colors.grey,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
