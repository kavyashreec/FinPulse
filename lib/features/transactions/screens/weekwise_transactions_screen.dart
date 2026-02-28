import 'package:flutter/material.dart';
import '../../notifications/notification_screen.dart';
import 'daywise_transactions_screen.dart';

class WeekwiseTransactionsScreen extends StatefulWidget {
  const WeekwiseTransactionsScreen({super.key});

  @override
  State<WeekwiseTransactionsScreen> createState() =>
      _WeekwiseTransactionsScreenState();
}

class _WeekwiseTransactionsScreenState
    extends State<WeekwiseTransactionsScreen> {

  int selectedTab = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF040B16),

      /// ✅ Bottom Nav Bar
      bottomNavigationBar: _bottomNav(),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [

              const SizedBox(height: 16),

              /// HEADER (Search Removed)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  const SizedBox(width: 40),

                  const Text(
                    "History",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const NotificationScreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.notifications_none,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              /// TOGGLE
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _topTab("Day Wise", 0),
                  const SizedBox(width: 32),
                  _topTab("Week Wise", 1),
                  const SizedBox(width: 32),
                  _topTab("Month Wise", 2),
                ],
              ),

              const SizedBox(height: 28),

              /// WEEK SELECTOR
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  const Icon(Icons.chevron_left,
                      color: Colors.white70),

                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0C1A2B),
                      borderRadius:
                          BorderRadius.circular(30),
                      border: Border.all(
                          color: Colors.white
                              .withOpacity(0.05)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 16,
                            color: Colors.white70),
                        SizedBox(width: 8),
                        Text(
                          "May 20 - May 26",
                          style: TextStyle(
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),

                  const Icon(Icons.chevron_right,
                      color: Colors.white70),
                ],
              ),

              const SizedBox(height: 30),

              /// TOTAL WEEK CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 26, vertical: 28),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(26),
                  gradient:
                      const LinearGradient(
                    begin: Alignment.topLeft,
                    end:
                        Alignment.bottomRight,
                    colors: [
                      Color(0xFF1E293B),
                      Color(0xFF0F172A),
                    ],
                  ),
                ),
                child: const Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      "TOTAL SPENDING FOR THE WEEK",
                      style: TextStyle(
                        fontSize: 13,
                        letterSpacing: 1.5,
                        color:
                            Color(0xFF94A3B8),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "-2,515.70",
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight:
                            FontWeight.w700,
                        color:
                            Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Weekly Categories",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              _weeklyCategoryCard(
                icon: Icons.shopping_bag,
                color: const Color(0xFF3B82F6),
                title: "Shopping",
                subtitle: "12 Transactions",
                amount: "-1,240.50",
                progress: 0.65,
              ),

              const SizedBox(height: 18),

              _weeklyCategoryCard(
                icon: Icons.receipt_long,
                color: const Color(0xFFFF8A34),
                title: "Bills & Utilities",
                subtitle: "4 Transactions",
                amount: "-850.00",
                progress: 0.45,
              ),

              const SizedBox(height: 30),

              /// ✅ Transactions Section Added
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Transactions of the Week",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              _transactionCard(
                icon: Icons.receipt_long,
                iconColor: const Color(0xFF3B82F6),
                title: "Monthly Rent",
                subtitle:
                    "10:00 PM · Wednesday, May 22",
                amount: "-950.00",
                category: "BILLS",
              ),

              const SizedBox(height: 16),

              _transactionCard(
                icon: Icons.directions_car,
                iconColor: const Color(0xFF22C55E),
                title: "Uber Trip",
                subtitle:
                    "06:20 PM · Wednesday, May 22",
                amount: "-24.50",
                category: "TRAVEL",
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topTab(String label, int index) {
    final isSelected = selectedTab == index;

    return GestureDetector(
      onTap: () {
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const DaywiseTransactionsScreen(),
            ),
          );
        }
      },
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight:
                  isSelected
                      ? FontWeight.w600
                      : FontWeight.w500,
              color: isSelected
                  ? Colors.white
                  : const Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 6),
          if (isSelected)
            Container(
              height: 2,
              width: 60,
              color: const Color(0xFF3B82F6),
            ),
        ],
      ),
    );
  }

  Widget _bottomNav() {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF0C1A2B),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white54,
      type: BottomNavigationBarType.fixed,
      currentIndex: 1,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.dashboard), label: "Home"),
        BottomNavigationBarItem(
            icon: Icon(Icons.history), label: "History"),
        BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart), label: "Insights"),
        BottomNavigationBarItem(
            icon: Icon(Icons.flag), label: "Goals"),
        BottomNavigationBarItem(
            icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }

  Widget _weeklyCategoryCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String amount,
    required double progress,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(26),
        gradient:
            const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0C1A2B),
            Color(0xFF08121F),
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.w600,
                            color:
                                Colors.white)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: const TextStyle(
                            fontSize: 13,
                            color:
                                Color(0xFF64748B))),
                  ],
                ),
              ),
              Text(amount,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.w600,
                      color: Colors.white)),
            ],
          ),
          const SizedBox(height: 14),
          LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor:
                Colors.white.withOpacity(0.1),
            valueColor:
                AlwaysStoppedAnimation(color),
          ),
        ],
      ),
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
        borderRadius:
            BorderRadius.circular(24),
        gradient:
            const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0C1A2B),
            Color(0xFF08121F),
          ],
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon,
                color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w600,
                        color:
                            Colors.white)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 13,
                        color:
                            Color(0xFF64748B))),
              ],
            ),
          ),
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              Text(amount,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.w600,
                      color:
                          Colors.redAccent)),
              const SizedBox(height: 6),
              Text(category,
                  style: const TextStyle(
                      fontSize: 12,
                      color:
                          Color(0xFF64748B))),
            ],
          ),
        ],
      ),
    );
  }
}