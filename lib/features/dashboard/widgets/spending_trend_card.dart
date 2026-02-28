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

  final List<double> data = [900, 1800, 2800, 3120];
  final double spacing = 1.0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
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

  List<FlSpot> _generateSpots(double progress) {
    return List.generate(
      data.length,
      (index) => FlSpot(index * spacing, data[index] * progress),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.fromLTRB(26, 22, 26, 14),

      /// MATCHED DARK CARD STYLE
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0C1A2B),
            Color(0xFF08121F),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withOpacity(0.25),
            blurRadius: 40,
            spreadRadius: -10,
            offset: const Offset(0, 25),
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Spending Trend",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF94A3B8),
                ),
              ),

              Row(
                children: const [
                  Icon(Icons.trending_down,
                      color: Color(0xFFFF6B4A), size: 18),
                  SizedBox(width: 4),
                  Text(
                    "-5%",
                    style: TextStyle(
                      color: Color(0xFFFF6B4A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            ],
          ),

          const SizedBox(height: 20),

          /// AMOUNT ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              Row(
                children: [
                  Text(
                    "\$3,120",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10),
                  Padding(
                    padding: EdgeInsets.only(bottom: 6),
                    child: Text(
                      "Total",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                "Last 30 Days",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                ),
              )
            ],
          ),

          const SizedBox(height: 24),

          /// GRAPH
          SizedBox(
            height: 160,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, _) {
                return LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: (data.length - 1) * spacing,
                    minY: 0,
                    maxY: 3500,
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
                          interval: spacing,
                          reservedSize: 36,
                          getTitlesWidget: (value, meta) {
                            int index =
                                (value / spacing).round();

                            if (index < 0 ||
                                index >= data.length) {
                              return const SizedBox();
                            }

                            return Padding(
                              padding:
                                  const EdgeInsets.only(top: 12),
                              child: Text(
                                "WK${index + 1}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    lineBarsData: [
                      LineChartBarData(
                        spots: _generateSpots(_animation.value),
                        isCurved: true,
                        curveSmoothness: 0.45,
                        color: const Color(0xFF243B55),
                        barWidth: 3,

                        dotData: FlDotData(
                          show: true,
                          getDotPainter:
                              (spot, percent, barData, index) {
                            if (index == data.length - 1) {
                              return FlDotCirclePainter(
                                radius: 6,
                                color: Colors.white,
                                strokeWidth: 0,
                              );
                            }
                            return FlDotCirclePainter(
                              radius: 0,
                              color: Colors.transparent,
                            );
                          },
                        ),

                        belowBarData: BarAreaData(
                          show: true,
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF2F4663),
                              Colors.transparent,
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