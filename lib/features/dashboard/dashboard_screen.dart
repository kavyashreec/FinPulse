import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'widgets/score_gauge.dart';
import 'widgets/income_expense_card.dart';
import 'widgets/spending_trend_card.dart';
import 'widgets/category_card.dart';
import 'widgets/recent_transactions_section.dart';
import '../notifications/notification_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ── Pure near-black background matching the reference ──────────
      backgroundColor: const Color(0xFF080B10),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 24),

              /// ── HEADER ───────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF141E2B),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.wallet_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "FinPulse",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  /// 🔔 NOTIFICATION BELL
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationScreen(),
                        ),
                      );
                    },
                    child: Stack(
                      children: const [
                        Icon(
                          Icons.notifications_none,
                          color: Colors.white70,
                          size: 26,
                        ),
                        Positioned(
                          right: 2,
                          top: 2,
                          child: CircleAvatar(
                            radius: 4,
                            backgroundColor: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 400.ms),

              const SizedBox(height: 40),

              /// ── SCORE GAUGE ──────────────────────────────────────────
              ScoreGauge()
                  .animate()
                  .fadeIn(delay: 200.ms)
                  .moveY(begin: 20, end: 0),

              const SizedBox(height: 32),

              /// ── INCOME VS EXPENSE ────────────────────────────────────
              IncomeExpenseCard()
                  .animate()
                  .fadeIn(delay: 300.ms)
                  .moveY(begin: 30, end: 0),

              const SizedBox(height: 16),

              /// ── SPENDING TREND ───────────────────────────────────────
              SpendingTrendCard()
                  .animate()
                  .fadeIn(delay: 400.ms)
                  .moveY(begin: 30, end: 0),

              const SizedBox(height: 16),

              /// ── CATEGORY BREAKDOWN ───────────────────────────────────
              CategoryCard()
                  .animate()
                  .fadeIn(delay: 500.ms)
                  .moveY(begin: 30, end: 0),

              const SizedBox(height: 16),

              /// ── RECENT TRANSACTIONS ──────────────────────────────────
              RecentTransactionsSection()
                  .animate()
                  .fadeIn(delay: 600.ms)
                  .moveY(begin: 30, end: 0),

              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}
