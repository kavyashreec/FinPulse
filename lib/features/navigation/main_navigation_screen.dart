import 'package:flutter/material.dart';

import '../dashboard/dashboard_screen.dart';
import '../transactions/screens/transactions_screen.dart';
import '../insights/insights_screen.dart';
import '../goals/goals_screen.dart';
import '../profile/screens/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState
    extends State<MainNavigationScreen> {

  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    TransactionsScreen(),
    InsightsScreen(),
    GoalsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: "Dashboard"),
          BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: "Transactions"),
          BottomNavigationBarItem(
              icon: Icon(Icons.analytics),
              label: "Insights"),
          BottomNavigationBarItem(
              icon: Icon(Icons.flag),
              label: "Goals"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile"),
        ],
      ),
    );
  }
}