import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Needs = Bills, Health, Groceries, Transport
/// Wants = Food, Shopping, Entertainment, + rest
const _needsCategories  = {'Bills', 'Health', 'Groceries', 'Transport'};
const _wantsCategories  = {'Food', 'Shopping', 'Entertainment'};

class CashFlowAllocationsCard extends StatefulWidget {
  final double income;
  final double expense;
  final Map<String, double> categoryTotals;

  const CashFlowAllocationsCard({
    super.key,
    required this.income,
    required this.expense,
    required this.categoryTotals,
  });

  @override
  State<CashFlowAllocationsCard> createState() =>
      _CashFlowAllocationsCardState();
}

class _CashFlowAllocationsCardState extends State<CashFlowAllocationsCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _anim =
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  double get _needs => widget.categoryTotals.entries
      .where((e) => _needsCategories.contains(e.key))
      .fold(0.0, (sum, e) => sum + e.value);

  double get _wants => widget.categoryTotals.entries
      .where((e) => _wantsCategories.contains(e.key))
      .fold(0.0, (sum, e) => sum + e.value);

  @override
  Widget build(BuildContext context) {
    final income  = widget.income;
    final expense = widget.expense;
    final needs   = _needs;
    final wants   = _wants;
    final total   = needs + wants;

    final needsPct = total > 0 ? (needs / total * 100).round() : 0;
    final wantsPct = total > 0 ? (wants / total * 100).round() : 0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Left: Cash Flow ──────────────────────────
        Expanded(
          child: _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Cash Flow',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF8BA3C7))),
                const SizedBox(height: 14),
                AnimatedBuilder(
                  animation: _anim,
                  builder: (_, __) => SizedBox(
                    height: 110,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _bar(income, income, expense, const Color(0xFF22C55E),
                            'INC', _anim.value),
                        _bar(expense, income, expense, const Color(0xFFEF4444),
                            'EXP', _anim.value),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),

        // ── Right: Allocations ───────────────────────
        Expanded(
          child: _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Allocations',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF8BA3C7))),
                const SizedBox(height: 10),
                AnimatedBuilder(
                  animation: _anim,
                  builder: (_, __) => Center(
                    child: SizedBox(
                      height: 90,
                      width: 90,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(90, 90),
                            painter: _DonutPainter(
                              needsFraction: total > 0
                                  ? (needs / total).clamp(0.0, 1.0)
                                  : 0.5,
                              progress: _anim.value,
                            ),
                          ),
                          Text(
                            '$needsPct/$wantsPct',
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(children: [
                  _dot(const Color(0xFF2D4A8A)),
                  const SizedBox(width: 4),
                  const Text('Needs',
                      style:
                          TextStyle(fontSize: 11, color: Color(0xFF8BA3C7))),
                  const SizedBox(width: 10),
                  _dot(const Color(0xFF8BA3C7).withOpacity(0.4)),
                  const SizedBox(width: 4),
                  const Text('Wants',
                      style:
                          TextStyle(fontSize: 11, color: Color(0xFF8BA3C7))),
                ]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _card({required Widget child}) => Container(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        decoration: BoxDecoration(
          color: const Color(0xFF0C1527),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF1A2C45)),
        ),
        child: child,
      );

  Widget _bar(double value, double income, double expense, Color color,
      String label, double progress) {
    final maxVal = income > expense ? income : expense;
    final frac   = maxVal > 0 ? (value / maxVal).clamp(0.0, 1.0) : 0.0;
    final maxH   = 75.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 36,
          height: maxH * frac * progress,
          decoration: BoxDecoration(
            color: color.withOpacity(0.85),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 5),
        Text(label,
            style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF8BA3C7),
                fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _dot(Color c) => Container(
      width: 8, height: 8, decoration: BoxDecoration(color: c, shape: BoxShape.circle));
}

class _DonutPainter extends CustomPainter {
  final double needsFraction;
  final double progress;

  _DonutPainter({required this.needsFraction, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center  = size.center(Offset.zero);
    final radius  = size.width / 2 - 8;
    const stroke  = 11.0;

    // Track
    final trackPaint = Paint()
      ..color = const Color(0xFF1A2C45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    final total = 2 * pi * progress;

    // Needs arc (dark blue)
    final needsPaint = Paint()
      ..color = const Color(0xFF2D4A8A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      total * needsFraction,
      false,
      needsPaint,
    );

    // Wants arc (muted blue-grey)
    final wantsPaint = Paint()
      ..color = const Color(0xFF8BA3C7).withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2 + total * needsFraction,
      total * (1 - needsFraction),
      false,
      wantsPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => true;
}
