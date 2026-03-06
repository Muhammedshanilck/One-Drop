import 'package:flutter/material.dart';
import 'package:one_drop/features/home/widgets/stat_card.dart';


class StatsRow extends StatelessWidget {
  const StatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: StatCard(
            title: "Total Donates",
            value: "0",
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: StatCard(
            title: "Total Requests",
            value: "0",
          ),
        ),
      ],
    );
  }
}