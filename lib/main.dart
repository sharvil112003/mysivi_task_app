import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      ),
    ),
  );
}
