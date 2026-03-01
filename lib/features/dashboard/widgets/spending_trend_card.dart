import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SpendingTrendCard extends StatefulWidget {
  final List<double> weeklyData;
  final double totalExpense;
  const SpendingTrendCard(
      {super.key, required this.weeklyData, required this.totalExpense});
  @override
  State<SpendingTrendCard> createState() => _SpendingTrendCardState();
}

class _SpendingTrendCardState extends State<SpendingTrendCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<FlSpot> _spots(double progress) {
    final data = widget.weeklyData;
    if (data.isEmpty) return [const FlSpot(0, 0)];
    return List.generate(
        data.length, (i) => FlSpot(i.toDouble(), data[i] * progress));
  }

  @override
  Widget build(BuildContext context) {
    final data   = widget.weeklyData;
    final maxVal = data.isNotEmpty ? data.reduce((a, b) => a > b ? a : b) : 1000;
    final total  = widget.totalExpense;

    double pct = 0;
    if (data.length >= 2 && data[data.length - 2] > 0) {
      pct = (data.last - data[data.length - 2]) /
          data[data.length - 2] *
          100;
    }
    final isUp = pct >= 0;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      decoration: BoxDecoration(
        color: const Color(0xFF0C1527),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1A2C45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row ─────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Spending Trend',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF8BA3C7))),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '₹${_fmt(total)}',
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.5),
                    ),
                    const SizedBox(width: 6),
                    const Text('Total',
                        style: TextStyle(
                            fontSize: 13, color: Color(0xFF8BA3C7))),
                  ],
                ),
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Row(children: [
                  Icon(
                    isUp
                        ? Icons.trending_up_rounded
                        : Icons.trending_down_rounded,
                    color: isUp
                        ? const Color(0xFFEF4444)
                        : const Color(0xFF22C55E),
                    size: 15,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${pct.abs().toStringAsFixed(0)}%',
                    style: TextStyle(
                        color: isUp
                            ? const Color(0xFFEF4444)
                            : const Color(0xFF22C55E),
                        fontWeight: FontWeight.w700,
                        fontSize: 14),
                  ),
                ]),
                const SizedBox(height: 2),
                const Text('Last 30 Days',
                    style:
                        TextStyle(color: Color(0xFF8BA3C7), fontSize: 10)),
              ]),
            ],
          ),

          const SizedBox(height: 10),

          // ── Chart ───────────────────────────────────
          SizedBox(
            height: 110,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, _) {
                return LineChart(LineChartData(
                  minX: 0,
                  maxX: (data.length - 1).toDouble().clamp(1, 100),
                  minY: 0,
                  maxY: maxVal * 1.25,
                  clipData: const FlClipData.all(),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 26,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final i = value.toInt();
                          if (i >= 0 && i < data.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text('WK${i + 1}',
                                  style: const TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF8BA3C7))),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _spots(_animation.value),
                      isCurved: true,
                      curveSmoothness: 0.45,
                      color: const Color(0xFF4F8EF7),
                      barWidth: 2,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          if (index == data.length - 1) {
                            return FlDotCirclePainter(
                                radius: 4,
                                color: Colors.white,
                                strokeWidth: 0);
                          }
                          return FlDotCirclePainter(
                              radius: 0,
                              color: Colors.transparent,
                              strokeWidth: 0);
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFF1A3A6E).withOpacity(0.3),
                            const Color(0xFF0C1527).withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ));
              },
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(double v) {
    if (v >= 1000) {
      final t = (v / 1000).floor();
      final r = (v % 1000).toInt();
      return '$t,${r.toString().padLeft(3, '0')}';
    }
    return v.toStringAsFixed(0);
  }
}