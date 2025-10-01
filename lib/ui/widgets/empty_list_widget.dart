import 'package:flutter/material.dart';

class EmptyListWidget extends StatelessWidget {
  const EmptyListWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          // Image.asset('assets/images/empty_list.png', height: 220),
          const SizedBox(height: 12),
          const Text('No patients found', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
