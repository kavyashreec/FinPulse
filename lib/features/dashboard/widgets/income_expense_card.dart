import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class IncomeExpenseCard extends StatefulWidget {
  const IncomeExpenseCard({super.key});

  @override
  State<IncomeExpenseCard> createState() => _IncomeExpenseCardState();
}

class _IncomeExpenseCardState extends State<IncomeExpenseCard>
    with SingleTickerProviderStateMixin {
  String selectedMonth = "MAY";

  late AnimationController _controller;
  late Animation<double> _animation;

  final Map<String, List<double>> _monthData = {
    "JAN": [3800, 2400],
    "FEB": [4100, 2700],
    "MAR": [3600, 3100],
    "APR": [4500, 2600],
    "MAY": [4200, 2850],
    "JUN": [3900, 2950],
    "JUL": [4300, 2750],
    "AUG": [4600, 3000],
    "SEP": [4000, 2650],
    "OCT": [4200, 2800],
    "NOV": [4400, 3100],
    "DEC": [5100, 3400],
  };

  static const List<String> _months = [
    "JAN", "FEB", "MAR", "APR", "MAY",
    "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC",
  ];

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

  void _selectMonth(String month) {
    setState(() => selectedMonth = month);
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final data = _monthData[selectedMonth]!;
    final income = data[0];
    final expense = data[1];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFF0D1117),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// ── HEADER ROW ─────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Income vs Expense",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF94A3B8),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.trending_up_rounded,
                          color: Color(0xFF22C55E), size: 17),
                      SizedBox(width: 2),
                      Text(
                        "12%",
                        style: TextStyle(
                          color: Color(0xFF22C55E),
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    "This Month",
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// ── AMOUNT ROW ─────────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                "\$${_fmt(income)}",
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF22C55E),
                  letterSpacing: -0.5,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "/",
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFF475569),
                  ),
                ),
              ),
              Text(
                "\$${_fmt(expense)}",
                style: const TextStyle(
                  fontSize: 28,
                  color: Color(0xFFEF4444),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// ── BAR CHART (tappable, all 12 months) ────────────────────
          SizedBox(
            height: 130,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, _) {
                return BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 55,
                    minY: 0,
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchCallback: (event, response) {
                        if (event is FlTapUpEvent &&
                            response != null &&
                            response.spot != null) {
                          final index =
                              response.spot!.touchedBarGroupIndex;
                          if (index >= 0 && index < _months.length) {
                            _selectMonth(_months[index]);
                          }
                        }
                      },
                      mouseCursorResolver: (_, __) =>
                          SystemMouseCursors.click,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (_) => Colors.transparent,
                        getTooltipItem: (_, __, ___, ____) => null,
                      ),
                    ),
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
                          reservedSize: 28,
                          getTitlesWidget: (value, meta) {
                            final i = value.toInt();
                            if (i < 0 || i >= _months.length) {
                              return const SizedBox();
                            }
                            final isSelected = _months[i] == selectedMonth;
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                _months[i],
                                style: TextStyle(
                                  fontSize: 9.5,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF475569),
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    barGroups: List.generate(_months.length, (i) {
                      final m = _months[i];
                      final incomeVal =
                          (_monthData[m]![0] / 100) * _animation.value;
                      final expenseVal =
                          (_monthData[m]![1] / 100) * _animation.value;
                      final isSelected = m == selectedMonth;
                      return BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: incomeVal,
                            width: 5,
                            borderRadius: BorderRadius.circular(4),
                            color: isSelected
                                ? const Color(0xFF22C55E)
                                : const Color(0xFF22C55E).withOpacity(0.25),
                          ),
                          BarChartRodData(
                            toY: expenseVal,
                            width: 5,
                            borderRadius: BorderRadius.circular(4),
                            color: isSelected
                                ? const Color(0xFFEF4444)
                                : const Color(0xFFEF4444).withOpacity(0.2),
                          ),
                        ],
                        barsSpace: 3,
                      );
                    }),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(double v) {
    if (v >= 1000) {
      final thousands = (v / 1000).floor();
      final remainder = (v % 1000).toInt();
      return "$thousands,${remainder.toString().padLeft(3, '0')}";
    }
    return v.toStringAsFixed(0);
  }
}
