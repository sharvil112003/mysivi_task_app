import 'package:flutter/material.dart';

Future<String?> showAddUserDialog(BuildContext context) async {
  final controller = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: const Text('Add User'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isEmpty) return;
              Navigator.pop(context, name);
            },
            child: const Text('Add'),
          ),
        ],
      );
    },
  );
}
