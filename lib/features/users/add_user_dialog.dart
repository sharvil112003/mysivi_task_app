import 'package:flutter/material.dart';

Future<String?> showAddUserDialog(BuildContext context) async {
  final controller = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (_) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Add User'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter name',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',style: TextStyle(color: Colors.blue),),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            onPressed: () {
              final name = controller.text.trim();
              if (name.isEmpty) return;
              Navigator.pop(context, name);
            },
            child: const Text('Add',style: TextStyle(color: Colors.white),),
          ),
        ],
      );
    },
  );
}
