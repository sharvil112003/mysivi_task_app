import 'package:flutter/material.dart';

Future<String?> showAddUserDialog(BuildContext context) async {
  final controller = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Add User', style: Theme.of(dialogContext).textTheme.titleLarge?.copyWith(fontSize: 18, fontWeight: FontWeight.w600)),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter name',
            hintStyle: Theme.of(dialogContext).inputDecorationTheme.hintStyle ?? Theme.of(dialogContext).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF2769FC))),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',style: Theme.of(dialogContext).textTheme.labelLarge?.copyWith(color: const Color(0xFF2769FC)),),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2769FC),
            ),
            onPressed: () {
              final name = controller.text.trim();
              if (name.isEmpty) return;
              Navigator.pop(context, name);
            },
            child: Text('Add',style: Theme.of(dialogContext).textTheme.labelLarge?.copyWith(color: Colors.white),),
          ),
        ],
      );
    },
  );
}
