import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SpendingTrendCard extends StatefulWidget {
  const SpendingTrendCard({super.key});

  @override
  State<SpendingTrendCard> createState() => _SpendingTrendCardState();
}

class _SpendingTrendCardState extends State<SpendingTrendCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  // Curve: starts low (WK1), rises to big peak (WK3), dips sharply, then shoots up (WK4)
  // Matches image 2: gentle rise → peak middle → valley → spike end
  final List<double> _data = [800, 1800, 2800, 3200, 1200, 600, 3600];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
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
    return List.generate(
      _data.length,
      (i) => FlSpot(i.toDouble(), _data[i] * progress),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFF0D1117),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// ── HEADER: Title+Amount left | Badge right ────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Left: title then amount stacked
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Spending Trend",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: const [
                      Text(
                        "\$3,120",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Total",
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              /// Right: percentage then "Last 30 Days" stacked
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.trending_down_rounded,
                          color: Color(0xFFEF4444), size: 16),
                      SizedBox(width: 3),
                      Text(
                        "5%",
                        style: TextStyle(
                          color: Color(0xFFEF4444),
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Last 30 Days",
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          /// ── LINE CHART ─────────────────────────────────────────────
          SizedBox(
            height: 160,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, _) {
                return LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: (_data.length - 1).toDouble(),
                    minY: 0,
                    maxY: 4000,
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
                          reservedSize: 32,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            // WK1 at x=0, WK2 at x=2, WK3 at x=4, WK4 at x=6
                            const wkPositions = [0.0, 2.0, 4.0, 6.0];
                            const wkLabels = ["WK1", "WK2", "WK3", "WK4"];
                            for (int i = 0; i < wkPositions.length; i++) {
                              if ((value - wkPositions[i]).abs() < 0.1) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    wkLabels[i],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF475569),
                                    ),
                                  ),
                                );
                              }
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
                        color: const Color(0xFF3D5A80),
                        barWidth: 2.5,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            if (index == _data.length - 1) {
                              return FlDotCirclePainter(
                                radius: 5,
                                color: Colors.white,
                                strokeWidth: 0,
                              );
                            }
                            return FlDotCirclePainter(
                              radius: 0,
                              color: Colors.transparent,
                              strokeWidth: 0,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFF1E3A5F).withOpacity(0.35),
                              const Color(0xFF0D1117).withOpacity(0.0),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
