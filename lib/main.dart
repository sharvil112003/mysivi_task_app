import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysivi_task_app/app/routes/routes.dart';
import 'data/hive/hive_service.dart';
import 'features/shell/shell_page.dart';
import 'features/chat/chat_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.shell,
      getPages: [
        GetPage(name: Routes.shell, page: () => const ShellPage()),
        GetPage(name: Routes.chat, page: () => const ChatPage()),
      ],
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black87,
          titleTextStyle: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme).apply(bodyColor: Colors.black87, displayColor: Colors.black87),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        ),
        iconTheme: const IconThemeData(color: Colors.blue),
        ),
    ),
  );
}
