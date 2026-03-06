import 'package:flutter/material.dart';
import 'package:one_drop/core/theme/app_spacing.dart';
class AppScaffold extends StatelessWidget {
  final Widget child;
  final String? title;
  final bool showAppBar;

  const AppScaffold({
    super.key,
    required this.child,
    this.title,
    this.showAppBar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              title: Text(title ?? ''),
              centerTitle: true,
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: child,
        ),
      ),
    );
  }
}