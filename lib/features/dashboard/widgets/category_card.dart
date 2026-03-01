import 'package:flutter/material.dart';

class CategoryCard extends StatefulWidget {
  const CategoryCard({super.key});

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  String selectedTab = "Week";

  final List<Map<String, dynamic>> weeklyData = [
    {"title": "Bills",         "tx": "4 Transactions",  "amount": -1200.00},
    {"title": "Shopping",      "tx": "12 Transactions", "amount": -450.00},
    {"title": "Groceries",     "tx": "8 Transactions",  "amount": -210.80},
    {"title": "Food",          "tx": "28 Transactions", "amount": -320.50},
    {"title": "Transport",     "tx": "15 Transactions", "amount": -145.00},
    {"title": "Entertainment", "tx": "5 Transactions",  "amount": -89.99},
    {"title": "Health",        "tx": "3 Transactions",  "amount": -175.00},
    {"title": "Income",        "tx": "2 Transactions",  "amount": 3200.00},
  ];

  final List<Map<String, dynamic>> monthlyData = [
    {"title": "Bills",         "tx": "10 Transactions", "amount": -3400.00},
    {"title": "Shopping",      "tx": "42 Transactions", "amount": -1650.00},
    {"title": "Groceries",     "tx": "24 Transactions", "amount": -840.60},
    {"title": "Food",          "tx": "76 Transactions", "amount": -980.50},
    {"title": "Transport",     "tx": "52 Transactions", "amount": -520.00},
    {"title": "Entertainment", "tx": "18 Transactions", "amount": -360.00},
    {"title": "Health",        "tx": "9 Transactions",  "amount": -620.00},
    {"title": "Income",        "tx": "4 Transactions",  "amount": 9800.00},
  ];

  @override
  Widget build(BuildContext context) {
    final data = selectedTab == "Week" ? weeklyData : monthlyData;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0C1A2B), Color(0xFF08121F)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withOpacity(0.25),
            blurRadius: 40,
            spreadRadius: -10,
            offset: const Offset(0, 25),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [

          /// ── HEADER ─────────────────────────────────────────────────
          Row(
            children: [
              const Expanded(
                child: Text(
                  "Expense Split",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F1C2E),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _toggle("Week"),
                    _toggle("Month"),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 26),

          /// ── CATEGORY LIST ───────────────────────────────────────────
          ...data.asMap().entries.map((entry) {
            final item = entry.value;
            final isLast = entry.key == data.length - 1;
            final isIncome = (item["amount"] as double) > 0;

            return Column(
              children: [
                Row(
                  children: [
                    _iconFor(item["title"]),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item["title"],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item["tx"],
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "${isIncome ? '+' : '-'}\$${(item["amount"] as double).abs().toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isIncome
                            ? const Color(0xFF22C55E)
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
                if (!isLast) ...[
                  const SizedBox(height: 10),
                  Divider(color: Colors.white.withOpacity(0.05), height: 1),
                  const SizedBox(height: 10),
                ],
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _toggle(String label) {
    final bool isSelected = selectedTab == label;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: isSelected
            ? BoxDecoration(
                color: const Color(0xFF1F2F45),
                borderRadius: BorderRadius.circular(20),
              )
            : null,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color:
                isSelected ? Colors.white : const Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _iconFor(String title) {
    switch (title) {
      case "Bills":
        return _icon(Icons.receipt_long_rounded,       const Color(0xFF3B82F6));
      case "Shopping":
        return _icon(Icons.shopping_cart_rounded,      const Color(0xFFFF8A34));
      case "Groceries":
        return _icon(Icons.local_grocery_store_rounded,const Color(0xFF22C55E));
      case "Food":
        return _icon(Icons.restaurant_rounded,         const Color(0xFFEAB308));
      case "Transport":
        return _icon(Icons.directions_car_rounded,     const Color(0xFF8B5CF6));
      case "Entertainment":
        return _icon(Icons.movie_rounded,              const Color(0xFFEC4899));
      case "Health":
        return _icon(Icons.favorite_rounded,           const Color(0xFFEF4444));
      case "Income":
        return _icon(Icons.attach_money_rounded,       const Color(0xFF22C55E));
      default:
        return _icon(Icons.circle,                     Colors.grey);
    }
  }

  Widget _icon(IconData icon, Color color) {
    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }
}