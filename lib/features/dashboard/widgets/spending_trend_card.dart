import 'package:flutter/material.dart';

class SpendingTrendCard extends StatelessWidget {
  const SpendingTrendCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 150,
        child: Center(
          child: Text(
            "Spending Trend",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
    );
  }
}