import 'package:flutter/material.dart';

class IncomeExpenseCard extends StatefulWidget {
  const IncomeExpenseCard({super.key});

  @override
  State<IncomeExpenseCard> createState() => _IncomeExpenseCardState();
}

class _IncomeExpenseCardState extends State<IncomeExpenseCard> {

  String selectedMonth = "FEB";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.fromLTRB(26, 24, 26, 22),
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
            children: const [
              Text(
                "Income vs Expense",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF94A3B8),
                ),
              ),
              Row(
                children: [
                  Icon(Icons.trending_up,
                      color: Color(0xFF22C55E), size: 18),
                  SizedBox(width: 4),
                  Text(
                    "+12%",
                    style: TextStyle(
                      color: Color(0xFF22C55E),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          /// AMOUNT
          const Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "\$4,200",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text: "  /  ",
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFF475569),
                  ),
                ),
                TextSpan(
                  text: "\$2,850",
                  style: TextStyle(
                    fontSize: 28,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          /// MONTH SELECTOR (FIXED ALIGNMENT + INTERACTIVE)
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _months.length,
              separatorBuilder: (_, __) => const SizedBox(width: 26),
              itemBuilder: (context, index) {
                final month = _months[index];
                final isSelected = month == selectedMonth;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedMonth = month;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 8),
                    decoration: isSelected
                        ? BoxDecoration(
                            color: const Color(0xFF1F2F45),
                            borderRadius: BorderRadius.circular(30),
                          )
                        : null,
                    child: Text(
                      month,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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

/// ALL MONTHS
const List<String> _months = [
  "JAN",
  "FEB",
  "MAR",
  "APR",
  "MAY",
  "JUN",
  "JUL",
  "AUG",
  "SEP",
  "OCT",
  "NOV",
  "DEC",
];