import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysivi_task_app/app/routes/routes.dart';
import 'data/hive/hive_service.dart';
import 'features/shell/shell_page.dart';
import 'features/chat/chat_page.dart';

import 'dart:async';
import 'services/connectivity_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();

  runApp(const MyApp());
}
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatefulWidget {
  const MyApp({Key? key, this.connectivityService, this.home}) : super(key: key);

  final IConnectivityService? connectivityService;
  final Widget? home;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final IConnectivityService _connectivityService;
  StreamSubscription<bool>? _sub;
  bool _bannerVisible = false;

  @override
  void initState() {
    super.initState();
    _connectivityService = widget.connectivityService ?? ConnectivityService();
    _sub = _connectivityService.connectionStream.listen((connected) {
      if (!connected && !_bannerVisible) {
        _showOfflineBanner();
      } else if (connected && _bannerVisible) {
        _hideOfflineBanner();
      }
    });
  }


  void _showOfflineBanner() {
    final messenger = rootScaffoldMessengerKey.currentState;
    if (messenger == null) return;

    messenger.showMaterialBanner(
      MaterialBanner(
        leading: const Icon(Icons.wifi_off, color: Colors.black87),
        content: const Text('No internet connection. Messages or changes you make may not be saved on the app.'),
        backgroundColor: Colors.orange.shade100,
        actions: [
          TextButton(
            onPressed: () => _connectivityService.checkConnection(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );

    _bannerVisible = true;
  }

  void _hideOfflineBanner() {
    rootScaffoldMessengerKey.currentState?.hideCurrentMaterialBanner();
    _bannerVisible = false;
  }

  @override
  void dispose() {
    _sub?.cancel();
    _connectivityService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      home: widget.home,
      initialRoute: widget.home == null ? Routes.shell : null,
      getPages: widget.home == null
          ? [
              GetPage(name: Routes.shell, page: () => const ShellPage()),
              GetPage(name: Routes.chat, page: () => const ChatPage()),
            ]
          : null,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2769FC)),
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
        iconTheme: const IconThemeData(color: Color(0xFF2769FC)),
      ),
    );
  }
}
