import 'package:flutter/material.dart';

class RecentTransactionsSection extends StatelessWidget {
  const RecentTransactionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 200,
        child: Center(
          child: Text(
            "Recent Transactions",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
    );
  }
}