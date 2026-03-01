import 'package:flutter/material.dart';
import '../../transactions/screens/daywise_transactions_screen.dart';
import '../../navigation/main_navigation_screen.dart';

class RecentTransactionsSection extends StatelessWidget {
  const RecentTransactionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// HEADER
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Recent Transactions",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),

            GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MainNavigationScreen(initialIndex: 1),
                  ),
                  (route) => false,
                );
              },
              child: const Text(
                "View All",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF3B82F6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        /// TRANSACTION CARDS
        _transactionCard(
          icon: Icons.receipt_long,
          iconColor: const Color(0xFF3B82F6),
          title: "Monthly Rent",
          subtitle: "10:00 PM · Wednesday, May 22",
          amount: "-\$950.00",
          category: "BILLS",
        ),

        const SizedBox(height: 16),

        _transactionCard(
          icon: Icons.directions_car,
          iconColor: const Color(0xFF22C55E),
          title: "Uber Trip",
          subtitle: "06:20 PM · Wednesday, May 22",
          amount: "-\$24.50",
          category: "TRAVEL",
        ),

        const SizedBox(height: 16),

        _transactionCard(
          icon: Icons.restaurant,
          iconColor: const Color(0xFFFF8A34),
          title: "Starbucks Coffee",
          subtitle: "04:30 PM · Wednesday, May 22",
          amount: "-\$12.80",
          category: "FOOD",
        ),
      ],
    );
  }

  Widget _transactionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String amount,
    required String category,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0C1A2B),
            Color(0xFF08121F),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
        ),
      ),
      child: Row(
        children: [

          /// ICON
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),

          const SizedBox(width: 16),

          /// TEXT
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),

          /// AMOUNT + CATEGORY
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                category,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}