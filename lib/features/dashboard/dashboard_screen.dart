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
      backgroundColor: const Color(0xFF040B16),

      body: Stack(
        children: [

          /// 🌌 DARK BACKGROUND GRADIENT
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF071426),
                  Color(0xFF040B16),
                ],
              ),
            ),
          ),

          /// 🔵 SOFT RADIAL GLOW (TOP LEFT)
          Positioned(
            top: -120,
            left: -120,
            child: Container(
              height: 350,
              width: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0xFF1E3A8A),
                    Colors.transparent,
                  ],
                  stops: [0.0, 1.0],
                ),
              ),
            ),
          ),

          /// 🔵 SOFT RADIAL GLOW (RIGHT SIDE)
          Positioned(
            top: 200,
            right: -150,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0xFF1E40AF),
                    Colors.transparent,
                  ],
                  stops: [0.0, 1.0],
                ),
              ),
            ),
          ),

          /// 📱 MAIN CONTENT
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 24),

                  /// HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A2C42),
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
                              builder: (_) =>
                                  const NotificationScreen(),
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

                            /// 🔴 RED DOT
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

                  /// SCORE GAUGE
                  ScoreGauge()
                      .animate()
                      .fadeIn(delay: 200.ms)
                      .moveY(begin: 20, end: 0),

                  const SizedBox(height: 40),

                  /// INCOME VS EXPENSE
                  IncomeExpenseCard()
                      .animate()
                      .fadeIn(delay: 300.ms)
                      .moveY(begin: 30, end: 0),

                  const SizedBox(height: 24),

                  /// SPENDING TREND
                  SpendingTrendCard()
                      .animate()
                      .fadeIn(delay: 400.ms)
                      .moveY(begin: 30, end: 0),

                  const SizedBox(height: 24),

                  /// CATEGORY BREAKDOWN
                  CategoryCard()
                      .animate()
                      .fadeIn(delay: 500.ms)
                      .moveY(begin: 30, end: 0),

                  const SizedBox(height: 24),

                  /// RECENT TRANSACTIONS
                  RecentTransactionsSection()
                      .animate()
                      .fadeIn(delay: 600.ms)
                      .moveY(begin: 30, end: 0),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}