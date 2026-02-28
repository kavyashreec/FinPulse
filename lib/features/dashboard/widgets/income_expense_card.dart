import 'package:flutter/material.dart';

class IncomeExpenseCard extends StatelessWidget {
  const IncomeExpenseCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 25,
              offset: const Offset(0, 12),
            ),
        ],
        border: isDark
            ? Border.all(
                color: Colors.white.withOpacity(0.06),
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Income vs Expense",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
              Row(
                children: const [
                  Icon(
                    Icons.trending_up,
                    color: Color(0xFF22C55E),
                    size: 16,
                  ),
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

          const SizedBox(height: 18),

          /// MAIN VALUE
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "\$4,200",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  "/ \$2,850",
                  style: TextStyle(
                    fontSize: 18,
                    color: isDark
                        ? Colors.white.withOpacity(0.5)
                        : Colors.grey.shade500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 26),

          /// MONTH LABELS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _monthLabel("JAN", theme),
              _monthLabel("FEB", theme),
              _monthLabel("MAR", theme),
              _monthLabel("APR", theme),
              _monthLabel("MAY", theme),
            ],
          ),
        ],
      ),
    );
  }

  Widget _monthLabel(String text, ThemeData theme) {
    return Text(
      text,
      style: theme.textTheme.bodySmall?.copyWith(
        letterSpacing: 1,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}