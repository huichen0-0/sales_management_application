import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WidgetCard extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;

  const WidgetCard(
      {super.key,
      required this.items,
      required this.title,
      });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: items.map((item) {
                return TextButton(
                  onPressed: () {
                    context.go(item['link']);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(item['icon'], size: 32, color: Colors.lightBlue,),
                      const SizedBox(height: 4),
                      Text(item['label'],style: const TextStyle(color: Colors.lightBlue),),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
