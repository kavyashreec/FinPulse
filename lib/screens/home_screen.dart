import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../services/sms_service.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> transactions = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    final data = await DatabaseHelper.instance.getAllTransactions();
    setState(() {
      transactions = data;
    });
  }

  // ---------------------------
  // REFRESH FUNCTION
  // ---------------------------
  Future<void> refreshData() async {
    setState(() {
      isLoading = true;
    });

    await SMSService().fetchTransactionSMS();
    await loadTransactions();

    setState(() {
      isLoading = false;
    });
  }

  // ---------------------------
  // CATEGORY EMOJI
  // ---------------------------
  String getCategoryEmoji(String category) {
    switch (category) {
      case "Food":
        return "🍔";
      case "Shopping":
        return "🛒";
      case "Travel":
        return "✈️";
      case "Bills":
        return "💡";
      case "Entertainment":
        return "🎬";
      case "Health":
        return "💊";
      case "Transport":
        return "⛽";
      case "Groceries":
        return "🥦";
      case "Income":
        return "💰";
      default:
        return "📦";
    }
  }

  // ---------------------------
  // CATEGORY COLOR
  // ---------------------------
  Color getCategoryColor(String category) {
    switch (category) {
      case "Food":
        return Colors.orange;
      case "Shopping":
        return Colors.purple;
      case "Travel":
        return Colors.blue;
      case "Bills":
        return Colors.redAccent;
      case "Entertainment":
        return Colors.deepPurple;
      case "Health":
        return Colors.teal;
      case "Transport":
        return Colors.brown;
      case "Groceries":
        return Colors.green;
      case "Income":
        return Colors.green.shade700;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Analyzer"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refreshData,
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : transactions.isEmpty
              ? const Center(
                  child: Text(
                    "No transactions yet.\nTap refresh to fetch SMS.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: refreshData,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final tx = transactions[index];
                      final isDebit = tx['type'] == "Debit";
                      final category = tx['category'];
                      final categoryColor =
                          getCategoryColor(category);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 14),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              Text(
                                getCategoryEmoji(category),
                                style: const TextStyle(fontSize: 28),
                              ),
                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tx['merchant'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Container(
                                      padding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4),
                                      decoration: BoxDecoration(
                                        color: categoryColor
                                            .withOpacity(0.15),
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        "$category • ${tx['type']}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: categoryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Text(
                                "₹${tx['amount']}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isDebit
                                      ? Colors.red
                                      : Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
