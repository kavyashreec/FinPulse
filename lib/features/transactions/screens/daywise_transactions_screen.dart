import 'package:flutter/material.dart';
import 'dart:math';
import '../../notifications/notification_screen.dart';
import 'weekwise_transactions_screen.dart';

class DaywiseTransactionsScreen extends StatefulWidget {
  const DaywiseTransactionsScreen({super.key});

  @override
  State<DaywiseTransactionsScreen> createState() =>
      _DaywiseTransactionsScreenState();
}

class _DaywiseTransactionsScreenState
    extends State<DaywiseTransactionsScreen> {

  int selectedTab = 0;

  int selectedDay = DateTime.now().day;
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  final List<String> monthNames = const [
    "January","February","March","April","May","June",
    "July","August","September","October","November","December"
  ];

  List<int> getDaysInMonth(int year, int month) {
    final firstDayNextMonth =
        (month < 12)
            ? DateTime(year, month + 1, 1)
            : DateTime(year + 1, 1, 1);

    final lastDay =
        firstDayNextMonth.subtract(const Duration(days: 1));

    return List.generate(lastDay.day, (index) => index + 1);
  }

  List<Map<String, dynamic>> generateTransactions(int day) {
    final random = Random(day * selectedMonth * selectedYear);

    return [
      {
        "icon": Icons.home_rounded,
        "iconColor": const Color(0xFF3B82F6),
        "title": "Monthly Rent",
        "time": "10:00 PM",
        "amount": -900.0 - random.nextInt(120),
        "category": "BILLS",
      },
      {
        "icon": Icons.directions_car_rounded,
        "iconColor": const Color(0xFF22C55E),
        "title": "Uber Trip",
        "time": "06:20 PM",
        "amount": -20.0 - random.nextDouble() * 30,
        "category": "TRAVEL",
      },
      {
        "icon": Icons.restaurant_rounded,
        "iconColor": const Color(0xFFFF8A34),
        "title": "Starbucks Coffee",
        "time": "04:30 PM",
        "amount": -10.0 - random.nextDouble() * 15,
        "category": "FOOD",
      },
      {
        "icon": Icons.shopping_bag_rounded,
        "iconColor": const Color(0xFFEF4444),
        "title": "Shopping",
        "time": "02:15 PM",
        "amount": -50.0 - random.nextDouble() * 200,
        "category": "SHOPPING",
      },
      {
        "icon": Icons.attach_money_rounded,
        "iconColor": const Color(0xFF22C55E),
        "title": "Freelance Payment",
        "time": "09:00 AM",
        "amount": 150.0 + random.nextDouble() * 250,
        "category": "INCOME",
      },
    ];
  }

  double calculateTotal(List<Map<String, dynamic>> list) {
    return list.fold(0.0, (sum, item) => sum + item["amount"]);
  }

  @override
  Widget build(BuildContext context) {

    final days = getDaysInMonth(selectedYear, selectedMonth);

    if (!days.contains(selectedDay)) {
      selectedDay = days.last;
    }

    final transactions = generateTransactions(selectedDay);
    final total = calculateTotal(transactions);

    return Scaffold(
      backgroundColor: const Color(0xFF040B16),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [

              const SizedBox(height: 16),

              /// HEADER
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
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _topTab("Day Wise", 0),
                    const SizedBox(width: 32),
                    _topTab("Week Wise", 1),
                    const SizedBox(width: 32),
                    _topTab("Month Wise", 2),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              /// MONTH + YEAR
              Row(
                children: [
                  Expanded(
                    child: DropdownButton<int>(
                      isExpanded: true,
                      value: selectedMonth,
                      dropdownColor: const Color(0xFF0C1A2B),
                      style: const TextStyle(color: Colors.white),
                      underline: const SizedBox(),
                      items: List.generate(
                        12,
                        (index) => DropdownMenuItem(
                          value: index + 1,
                          child: Text(monthNames[index]),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          selectedMonth = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 100,
                    child: DropdownButton<int>(
                      isExpanded: true,
                      value: selectedYear,
                      dropdownColor: const Color(0xFF0C1A2B),
                      style: const TextStyle(color: Colors.white),
                      underline: const SizedBox(),
                      items: List.generate(
                        5,
                        (index) {
                          final year =
                              DateTime.now().year - 2 + index;
                          return DropdownMenuItem(
                            value: year,
                            child: Text("$year"),
                          );
                        },
                      ),
                      onChanged: (value) {
                        setState(() {
                          selectedYear = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// DAY SELECTOR
              SizedBox(
                height: 68,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: days.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {

                    final day = days[index];
                    final isSelected = selectedDay == day;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDay = day;
                        });
                      },
                      child: Container(
                        width: 56,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(16),
                          color: isSelected
                              ? const Color(0xFF243447)
                              : const Color(0xFF0C1A2B),
                        ),
                        child: Center(
                          child: Text(
                            "$day",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight:
                                  FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(
                                      0xFF94A3B8),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 28),

              /// TOTAL CARD
              _buildTotalCard(total),

              const SizedBox(height: 28),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Transactions of the Day",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Column(
                children: transactions.map((tx) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(bottom: 14),
                    child: _transactionCard(
                      icon: tx["icon"],
                      iconColor: tx["iconColor"],
                      title: tx["title"],
                      subtitle:
                          "${tx["time"]} • $selectedDay ${monthNames[selectedMonth - 1]}, $selectedYear",
                      amount: tx["amount"],
                      category: tx["category"],
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topTab(String label, int index) {
    return GestureDetector(
      onTap: () {
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const WeekwiseTransactionsScreen(),
            ),
          );
          return;
        }
      },
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight:
                  index == 0
                      ? FontWeight.w600
                      : FontWeight.w500,
              color: index == 0
                  ? Colors.white
                  : const Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 6),
          if (index == 0)
            Container(
              height: 2,
              width: 60,
              color: const Color(0xFF3B82F6),
            ),
        ],
      ),
    );
  }

  Widget _buildTotalCard(double total) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          horizontal: 26, vertical: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF3A4759),
            Color(0xFF243447),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            "TOTAL SPENT (${_weekdayName(selectedYear, selectedMonth, selectedDay)}, ${selectedDay}${_ordinal(selectedDay)})",
            style: const TextStyle(
              fontSize: 13,
              letterSpacing: 1.5,
              color: Color(0xFFCBD5E1),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            total.toStringAsFixed(2),
            style: TextStyle(
              fontSize: 40,
              fontWeight:
                  FontWeight.w700,
              color: total >= 0
                  ? const Color(0xFF22C55E)
                  : const Color(0xFFEF4444),
            ),
          ),
        ],
      ),
    );
  }

  String _weekdayName(int year, int month, int day) {
    final date = DateTime(year, month, day);
    const names = ["MON","TUE","WED","THU","FRI","SAT","SUN"];
    return names[date.weekday - 1];
  }

  String _ordinal(int day) {
    if (day >= 11 && day <= 13) return "TH";
    switch (day % 10) {
      case 1: return "ST";
      case 2: return "ND";
      case 3: return "RD";
      default: return "TH";
    }
  }

  Widget _transactionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required double amount,
    required String category,
  }) {
    final bool isIncome = amount > 0;

    return Container(
      padding: const EdgeInsets.all(18),
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
        border: Border.all(
          color: Colors.white
              .withOpacity(0.05),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: iconColor
                  .withOpacity(0.15),
              shape:
                  BoxShape.circle,
            ),
            child: Icon(icon,
                color: iconColor,
                size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(title,
                    style:
                        const TextStyle(
                  fontSize: 17,
                  fontWeight:
                      FontWeight.w600,
                  color:
                      Colors.white,
                )),
                const SizedBox(height: 6),
                Text(subtitle,
                    style:
                        const TextStyle(
                  fontSize: 13,
                  color: Color(
                      0xFF64748B),
                )),
              ],
            ),
          ),
          Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .end,
            children: [
              Text(
                amount
                    .abs()
                    .toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 17,
                  fontWeight:
                      FontWeight.w600,
                  color: isIncome
                      ? const Color(
                          0xFF22C55E)
                      : const Color(
                          0xFFEF4444),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                category,
                style:
                    const TextStyle(
                  fontSize: 12,
                  color:
                      Color(0xFF64748B),
                  fontWeight:
                      FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}