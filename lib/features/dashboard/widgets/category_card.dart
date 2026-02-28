import 'package:flutter/material.dart';

class CategoryCard extends StatefulWidget {
  const CategoryCard({super.key});

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  String selectedTab = "Week";

  /// Dummy Data
  final List<Map<String, dynamic>> weeklyData = [
    {"title": "Shopping", "tx": "12 Transactions", "amount": -450.00},
    {"title": "Bills", "tx": "4 Transactions", "amount": -1200.00},
    {"title": "Food & Drink", "tx": "28 Transactions", "amount": -320.50},
    {"title": "Travel", "tx": "1 Transaction", "amount": -850.00},
    {"title": "Transport", "tx": "15 Transactions", "amount": -145.00},
  ];

  final List<Map<String, dynamic>> monthlyData = [
    {"title": "Shopping", "tx": "42 Transactions", "amount": -1650.00},
    {"title": "Bills", "tx": "10 Transactions", "amount": -2800.00},
    {"title": "Food & Drink", "tx": "76 Transactions", "amount": -980.50},
    {"title": "Travel", "tx": "3 Transactions", "amount": -1450.00},
    {"title": "Transport", "tx": "52 Transactions", "amount": -520.00},
  ];

  @override
  Widget build(BuildContext context) {
    final data =
        selectedTab == "Week" ? weeklyData : monthlyData;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
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
        children: [

          /// HEADER
          Row(
            children: [
              Expanded(
                child: Text(
                  "Expense Split",
                  style: const TextStyle(
                    fontSize: 18, // reduced
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2, // tighter spacing
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(width: 10),

              /// SMALLER TOGGLE
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

          /// CATEGORY LIST
          ...data.asMap().entries.map((entry) {
            final item = entry.value;
            final isLast = entry.key == data.length - 1;

            return Padding(
              padding:
                  EdgeInsets.only(bottom: isLast ? 0 : 22),
              child: Row(
                children: [

                  /// ICON
                  _iconFor(item["title"]),

                  const SizedBox(width: 16),

                  /// TEXT
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
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

                  /// AMOUNT
                  Text(
                    "\$${item["amount"].toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _toggle(String label) {
    final bool isSelected = selectedTab == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: isSelected
            ? BoxDecoration(
                color: const Color(0xFF1F2F45),
                borderRadius: BorderRadius.circular(20),
              )
            : null,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13, // smaller toggle text
            color: isSelected
                ? Colors.white
                : const Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _iconFor(String title) {
    switch (title) {
      case "Shopping":
        return _icon(Icons.shopping_cart,
            const Color(0xFFFF8A34));
      case "Bills":
        return _icon(
            Icons.receipt_long, const Color(0xFF3B82F6));
      case "Food & Drink":
        return _icon(
            Icons.restaurant, const Color(0xFFFF6B4A));
      case "Travel":
        return _icon(Icons.flight, const Color(0xFF8B5CF6));
      case "Transport":
        return _icon(
            Icons.directions_car, const Color(0xFF22C55E));
      default:
        return _icon(Icons.circle, Colors.grey);
    }
  }

  Widget _icon(IconData icon, Color color) {
    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}