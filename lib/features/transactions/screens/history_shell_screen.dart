import 'package:flutter/material.dart';
import 'daywise_transactions_screen.dart';
import 'weekwise_transactions_screen.dart';
import 'monthwise_transactions_screen.dart';
// Note: history_shell_screen.dart lives in features/transactions/screens/
// main_navigation_screen.dart lives in features/navigation/

/// This shell is what MainNavigationScreen places at History index.
/// It owns the tab state so switching Daily/Weekly/Monthly never
/// leaves the MainNavigationScreen scaffold, keeping the bottom nav visible.
class HistoryShellScreen extends StatefulWidget {
  const HistoryShellScreen({super.key});

  @override
  State<HistoryShellScreen> createState() => _HistoryShellScreenState();
}

class _HistoryShellScreenState extends State<HistoryShellScreen> {
  int _selectedTab = 0; // 0=Daily, 1=Weekly, 2=Monthly

  void _switchTab(int index) {
    setState(() => _selectedTab = index);
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: _selectedTab,
      children: [
        DaywiseTransactionsScreen(onTabSwitch: _switchTab, selectedTab: 0),
        WeekwiseTransactionsScreen(onTabSwitch: _switchTab, selectedTab: 1),
        MonthwiseTransactionsScreen(onTabSwitch: _switchTab, selectedTab: 2),
      ],
    );
  }
}
