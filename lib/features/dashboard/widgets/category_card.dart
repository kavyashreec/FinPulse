import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 200,
        child: Center(
          child: Text(
            "Spending by Category",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
    );
  }
}