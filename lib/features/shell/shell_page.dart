import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysivi_task_app/features/offers/offers.dart';
import 'package:mysivi_task_app/features/settings/settings.dart';
import 'shell_controller.dart';
import '../home/home_page.dart';

class ShellPage extends StatelessWidget {
  const ShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ShellController());

    return Obx(() {
      return Scaffold(
        body: IndexedStack(
          index: c.index.value,
          children: const [
            HomePage(),
            Offers(),
            Settings(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: c.index.value,
          onTap: c.setIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.local_offer_outlined), label: 'Offers'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          ],
        ),
      );
    });
  }
}
