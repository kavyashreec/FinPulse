import '../local/database_helper.dart';

/// Calculates a 0–100 financial health score based on:
///  - Savings rate      (40 pts)
///  - Expense diversity (20 pts)
///  - Consistency       (20 pts)
///  - Goal progress     (20 pts)
class ScoreService {
  final _db = DatabaseHelper.instance;

  Future<double> calculateScore() async {
    final now   = DateTime.now();
    final start = DateTime(now.year, now.month - 2, 1); // last ~3 months
    final end   = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    final income  = await _db.getTotalIncome(start: start, end: end);
    final expense = await _db.getTotalExpense(start: start, end: end);
    final goals   = await _db.getAllGoals();

    // ── 1. Savings rate (40 pts) ───────────────────────────
    double savingsScore = 0;
    if (income > 0) {
      final savingsRate = (income - expense) / income; // -∞ to 1
      if (savingsRate >= 0.30)      savingsScore = 40;
      else if (savingsRate >= 0.20) savingsScore = 32;
      else if (savingsRate >= 0.10) savingsScore = 22;
      else if (savingsRate >= 0.00) savingsScore = 12;
      else                          savingsScore = 0;   // spending > income
    }

    // ── 2. Expense diversity (20 pts) ─────────────────────
    // Penalise if a single category > 60 % of total spend
    double diversityScore = 20;
    if (expense > 0) {
      final cats = await _db.getCategoryTotals(start: start, end: end);
      if (cats.isNotEmpty) {
        final maxShare = cats.values.reduce((a, b) => a > b ? a : b) / expense;
        if (maxShare > 0.80)      diversityScore = 5;
        else if (maxShare > 0.60) diversityScore = 12;
        else if (maxShare > 0.40) diversityScore = 16;
      }
    }

    // ── 3. Transaction consistency (20 pts) ───────────────
    // More transactions logged = better habit tracking
    final txCount = await _db.getTransactionCount();
    double consistencyScore;
    if (txCount >= 50)      consistencyScore = 20;
    else if (txCount >= 30) consistencyScore = 16;
    else if (txCount >= 15) consistencyScore = 11;
    else if (txCount >= 5)  consistencyScore = 6;
    else                    consistencyScore = 2;

    // ── 4. Goal progress (20 pts) ─────────────────────────
    double goalScore = 0;
    if (goals.isNotEmpty) {
      final avgProgress = goals
          .map((g) => (g.current / g.target).clamp(0.0, 1.0))
          .reduce((a, b) => a + b) /
          goals.length;
      goalScore = (avgProgress * 20).clamp(0, 20);
    }

    final total = (savingsScore + diversityScore + consistencyScore + goalScore)
        .clamp(0.0, 100.0);
    return double.parse(total.toStringAsFixed(1));
  }

  // ── Static helpers used directly in profile_screen ──────

  static String getScoreLabel(double score) {
    if (score >= 80) return 'EXCELLENT';
    if (score >= 65) return 'GOOD';
    if (score >= 45) return 'FAIR';
    return 'POOR';
  }

  /// Returns an ARGB int suitable for `Color(...)`.
  static int getScoreLabelColor(double score) {
    if (score >= 80) return 0xFF22C55E; // green
    if (score >= 65) return 0xFF84CC16; // lime
    if (score >= 45) return 0xFFF59E0B; // amber
    return 0xFFEF4444;                  // red
  }
}
