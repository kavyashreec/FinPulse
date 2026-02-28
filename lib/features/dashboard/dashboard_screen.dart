import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'widgets/score_gauge.dart';
import 'widgets/income_expense_card.dart';
import 'widgets/spending_trend_card.dart';
import 'widgets/category_card.dart';
import 'widgets/recent_transactions_section.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 20),

              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.wallet_rounded, size: 28),
                      const SizedBox(width: 8),
                      Text(
                        "FinPulse",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: const [
                      Icon(Icons.search),
                      SizedBox(width: 16),
                      Icon(Icons.notifications_none),
                    ],
                  )
                ],
              ).animate().fadeIn(duration: 400.ms),

              const SizedBox(height: 30),

              /// SCORE GAUGE
              ScoreGauge()
                  .animate()
                  .fadeIn(delay: 200.ms),

              const SizedBox(height: 30),

              /// INCOME VS EXPENSE
              IncomeExpenseCard()
                  .animate()
                  .fadeIn(delay: 300.ms),

              const SizedBox(height: 20),

              /// SPENDING TREND
              SpendingTrendCard()
                  .animate()
                  .fadeIn(delay: 400.ms),

              const SizedBox(height: 20),

              /// CATEGORY BREAKDOWN
              CategoryCard()
                  .animate()
                  .fadeIn(delay: 500.ms),

              const SizedBox(height: 20),

              /// RECENT TRANSACTIONS
              RecentTransactionsSection()
                  .animate()
                  .fadeIn(delay: 600.ms),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}