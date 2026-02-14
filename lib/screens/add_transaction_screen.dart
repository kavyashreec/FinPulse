import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController amountController = TextEditingController();
  final TextEditingController merchantController = TextEditingController();

  String selectedCategory = "Food";
  String selectedType = "Debit";

  final List<String> categories = [
    "Food",
    "Transport",
    "Shopping",
    "Groceries",
    "Bills",
    "Others"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Transaction")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Amount",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter amount";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: merchantController,
                decoration: const InputDecoration(
                  labelText: "Merchant",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter merchant name";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: categories
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: selectedType,
                items: ["Debit", "Credit"]
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedType = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: "Transaction Type",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () async {

                  if (_formKey.currentState!.validate()) {

                    await DatabaseHelper.instance.insertTransaction({
                      'amount': double.parse(amountController.text),
                      'merchant': merchantController.text,
                      'category': selectedCategory,
                      'type': selectedType,
                      'timestamp': DateTime.now().toString(),
                    });

                    Navigator.pop(context, true);
                  }
                },
                child: const Text("Save Transaction"),
              )

            ],
          ),
        ),
      ),
    );
  }
}
