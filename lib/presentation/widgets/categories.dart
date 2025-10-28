import 'package:flutter/material.dart';
class CategoryBox extends StatelessWidget {
  final String title;
  final Color? color;
  final int? count;

  const CategoryBox({
    super.key,
    required this.title,
    this.color,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding:  EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          if (count != null)
            Text(
              "$count",
              style: const TextStyle(color: Colors.white70),
            ),
        ],
      ),
    );
  }
}
