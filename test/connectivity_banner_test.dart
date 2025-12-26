import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysivi_task_app/main.dart';
import 'package:mysivi_task_app/services/connectivity_service.dart';

class FakeConnectivityService implements IConnectivityService {
  FakeConnectivityService(this._controller);

  final StreamController<bool> _controller;
  int checkCalls = 0;

  @override
  Stream<bool> get connectionStream => _controller.stream;

  @override
  Future<void> checkConnection() async {
    checkCalls++;
  }

  @override
  void dispose() {}
}

void main() {
  testWidgets('Shows offline banner on false and hides on true; Retry triggers check', (tester) async {
    final controller = StreamController<bool>.broadcast();

    final fake = FakeConnectivityService(controller);

    // Provide a minimal home to avoid initializing app routes (which require Hive).
    await tester.pumpWidget(MaterialApp(
      home: MyApp(connectivityService: fake, home: const Scaffold(body: SizedBox())),
    ));

    // Now signal offline
    controller.add(false);
    await tester.pumpAndSettle();

    // Banner content text used in the app
    expect(find.textContaining('No internet connection'), findsOneWidget);

    // Tap Retry and ensure checkConnection is called
    final retryFinder = find.widgetWithText(TextButton, 'Retry');
    expect(retryFinder, findsOneWidget);
    await tester.tap(retryFinder);
    await tester.pump();
    expect(fake.checkCalls, greaterThanOrEqualTo(1));

    // Now send connected=true and ensure banner disappears
    controller.add(true);
    await tester.pumpAndSettle();

    expect(find.textContaining('No internet connection'), findsNothing);

    await controller.close();
  });
}
