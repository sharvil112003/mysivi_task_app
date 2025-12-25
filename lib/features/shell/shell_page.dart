import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
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
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue,
          selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          unselectedItemColor: Colors.black,
          currentIndex: c.index.value,
          onTap: c.setIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(LucideIcons.messageCircleMore), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.local_offer_outlined), label: 'Offers'),
            BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
          ],
        ),
      );
    });
  }
}
