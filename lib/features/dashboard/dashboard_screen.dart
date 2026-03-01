import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../data/local/database_helper.dart';
import '../../data/models/transaction_model.dart';
import 'widgets/score_gauge.dart';
import 'widgets/cash_flow_allocations_card.dart';
import 'widgets/spending_trend_card.dart';
import 'widgets/category_card.dart';
import 'widgets/recent_transactions_section.dart';
import '../notifications/notification_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _db = DatabaseHelper.instance;
  double _income = 0;
  double _expense = 0;
  Map<String, double> _categoryTotals = {};
  Map<String, int> _categoryCounts = {};
  List<TransactionModel> _recentTx = [];
  List<double> _weeklyTrend = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    final income  = await _db.getTotalIncome(start: monthStart, end: monthEnd);
    final expense = await _db.getTotalExpense(start: monthStart, end: monthEnd);
    final cats    = await _db.getCategoryTotals(start: monthStart, end: monthEnd);
    final counts  = await _db.getCategoryCounts(start: monthStart, end: monthEnd);
    final recent  = await _db.getRecentTransactions(limit: 3);
    final trend   = await _db.getWeeklySpendingTrend();

    if (!mounted) return;
    setState(() {
      _income        = income;
      _expense       = expense;
      _categoryTotals = cats;
      _categoryCounts = counts;
      _recentTx      = recent;
      _weeklyTrend   = trend;
      _loading       = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFF060D18),
        body: Center(child: CircularProgressIndicator(color: Color(0xFF4F8EF7))),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF060D18),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 18),

              // ── Header ────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A2744),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.wallet_rounded,
                          color: Color(0xFF4F8EF7), size: 20),
                    ),
                    const SizedBox(width: 10),
                    const Text('FinPulse',
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.3)),
                  ]),
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(
                            builder: (_) => const NotificationScreen())),
                    child: Stack(children: const [
                      Icon(Icons.notifications_none,
                          color: Colors.white70, size: 25),
                      Positioned(
                        right: 2, top: 2,
                        child: CircleAvatar(
                            radius: 4, backgroundColor: Colors.redAccent),
                      ),
                    ]),
                  ),
                ],
              ).animate().fadeIn(duration: 400.ms),

              const SizedBox(height: 28),

              // ── Score Gauge ───────────────────────────
              ScoreGauge(income: _income, expense: _expense)
                  .animate()
                  .fadeIn(delay: 200.ms)
                  .moveY(begin: 16, end: 0),

              const SizedBox(height: 20),

              // ── Cash Flow + Allocations (side by side) ─
              CashFlowAllocationsCard(
                income: _income,
                expense: _expense,
                categoryTotals: _categoryTotals,
              ).animate().fadeIn(delay: 300.ms).moveY(begin: 20, end: 0),

              const SizedBox(height: 12),

              // ── Spending Trend ────────────────────────
              SpendingTrendCard(
                      weeklyData: _weeklyTrend, totalExpense: _expense)
                  .animate()
                  .fadeIn(delay: 400.ms)
                  .moveY(begin: 20, end: 0),

              const SizedBox(height: 12),

              // ── Category / Expense Split ──────────────
              CategoryCard(
                      categoryTotals: _categoryTotals,
                      categoryCounts: _categoryCounts)
                  .animate()
                  .fadeIn(delay: 500.ms)
                  .moveY(begin: 20, end: 0),

              const SizedBox(height: 12),

              // ── Recent Transactions ───────────────────
              RecentTransactionsSection(transactions: _recentTx)
                  .animate()
                  .fadeIn(delay: 600.ms)
                  .moveY(begin: 20, end: 0),

              const SizedBox(height: 110),
            ],
          ),
        ),
      ),
    );
  }
}
