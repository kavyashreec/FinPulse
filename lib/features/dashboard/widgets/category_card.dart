import 'package:flutter/material.dart';
import '../../../data/local/database_helper.dart';

class CategoryCard extends StatefulWidget {
  final Map<String, double> categoryTotals;
  final Map<String, int> categoryCounts;

  const CategoryCard({
    super.key,
    required this.categoryTotals,
    required this.categoryCounts,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  final _db = DatabaseHelper.instance;

  int  _selectedPeriod = 1; // 0 = Week, 1 = Month
  bool _loadingToggle  = false;

  Map<String, double> _totals = {};
  Map<String, int>    _counts = {};

  static const _order = [
    'Bills', 'Shopping', 'Health', 'Groceries',
    'Food', 'Transport', 'Entertainment', 'Income',
  ];

  @override
  void initState() {
    super.initState();
    _totals = Map.from(widget.categoryTotals);
    _counts = Map.from(widget.categoryCounts);
  }

  Future<void> _onToggle(int index) async {
    if (index == _selectedPeriod) return;
    setState(() {
      _selectedPeriod = index;
      _loadingToggle  = true;
    });

    final now = DateTime.now();
    late DateTime start, end;
    if (index == 0) {
      end   = DateTime(now.year, now.month, now.day, 23, 59, 59);
      start = end.subtract(const Duration(days: 6));
    } else {
      start = DateTime(now.year, now.month, 1);
      end   = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    }

    final totals = await _db.getCategoryTotals(start: start, end: end);
    final counts = await _db.getCategoryCounts(start: start, end: end);

    if (!mounted) return;
    setState(() {
      _totals        = totals;
      _counts        = counts;
      _loadingToggle = false;
    });
  }

  List<MapEntry<String, double>> get _sorted =>
      _order.map((k) => MapEntry(k, _totals[k] ?? 0.0)).toList();

  @override
  Widget build(BuildContext context) {
    final data = _sorted;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0C1527),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1A2C45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title + toggle INSIDE the card ───────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Spending by Category',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 32,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF081020),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFF1A2C45)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _pill('Week', 0),
                      _pill('Month', 1),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          Divider(height: 1, color: const Color(0xFF1A2C45).withOpacity(0.7)),

          // ── Rows ─────────────────────────────────────
          if (_loadingToggle)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: CircularProgressIndicator(
                    color: Color(0xFF4F8EF7), strokeWidth: 2),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: data.asMap().entries.map((e) {
                  final isLast = e.key == data.length - 1;
                  final cat    = e.value.key;
                  final amt    = e.value.value;
                  final count  = _counts[cat] ?? 0;
                  return Column(children: [
                    _row(cat, amt, count),
                    if (!isLast)
                      Divider(
                        height: 1,
                        indent: 70,
                        color: const Color(0xFF1A2C45).withOpacity(0.7),
                      ),
                  ]);
                }).toList(),
              ),
            ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _pill(String label, int index) {
    final active = _selectedPeriod == index;
    return GestureDetector(
      onTap: () => _onToggle(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF1A3266) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: active ? FontWeight.w700 : FontWeight.w400,
            color: active ? Colors.white : const Color(0xFF8BA3C7),
          ),
        ),
      ),
    );
  }

  Widget _row(String category, double amount, int count) {
    final isIncome = category == 'Income';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        children: [
          _iconFor(category),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
                const SizedBox(height: 3),
                Text(
                  '$count ${count == 1 ? 'item' : 'items'}',
                  style: const TextStyle(
                      fontSize: 12, color: Color(0xFF8BA3C7)),
                ),
              ],
            ),
          ),
          Text(
            isIncome ? '+₹${_fmt(amount)}' : '-₹${_fmt(amount)}',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isIncome ? const Color(0xFF22C55E) : Colors.white),
          ),
        ],
      ),
    );
  }

  String _fmt(double v) {
    if (v >= 1000) {
      final t = (v / 1000).floor();
      final r = (v % 1000).toInt();
      return '$t,${r.toString().padLeft(3, '0')}.00';
    }
    return v.toStringAsFixed(2);
  }

  Widget _iconFor(String cat) {
    switch (cat) {
      case 'Bills':
        return _icon(Icons.receipt_long_rounded,
            const Color(0xFF1A3266), const Color(0xFF4F8EF7));
      case 'Shopping':
        return _icon(Icons.shopping_cart_rounded,
            const Color(0xFF3D1F00), const Color(0xFFFF8A34));
      case 'Health':
        return _icon(Icons.favorite_rounded,
            const Color(0xFF3D0A0A), const Color(0xFFEF4444));
      case 'Groceries':
        return _icon(Icons.local_grocery_store_rounded,
            const Color(0xFF0A2E1A), const Color(0xFF22C55E));
      case 'Food':
        return _icon(Icons.restaurant_rounded,
            const Color(0xFF2E2000), const Color(0xFFEAB308));
      case 'Transport':
        return _icon(Icons.directions_car_rounded,
            const Color(0xFF1E0A3D), const Color(0xFF8B5CF6));
      case 'Entertainment':
        return _icon(Icons.movie_rounded,
            const Color(0xFF3D0A2E), const Color(0xFFEC4899));
      case 'Income':
        return _icon(Icons.attach_money_rounded,
            const Color(0xFF0A2E1A), const Color(0xFF22C55E));
      default:
        return _icon(Icons.category_rounded,
            const Color(0xFF1A2C45), const Color(0xFF8BA3C7));
    }
  }

  Widget _icon(IconData icon, Color bg, Color fg) => Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: Icon(icon, color: fg, size: 24),
      );
}
