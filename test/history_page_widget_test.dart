import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mysivi_task_app/features/history/history_page.dart';
import 'package:mysivi_task_app/features/history/history_controller.dart';
import 'package:mysivi_task_app/data/repos/chat_repo.dart';
import 'package:mysivi_task_app/data/models/chat_message.dart';
import 'package:mysivi_task_app/data/models/chat_session.dart';
import 'package:mysivi_task_app/data/models/app_user.dart';

class TestChatRepo extends ChatRepo {
  final List<ChatMessage> _messages = [];
  final Map<String, ChatSession> _sessions = {};

  void addMessageForTest(ChatMessage m) {
    _messages.add(m);
  }

  void addSessionForTest(ChatSession s) {
    _sessions[s.userId] = s;
  }

  @override
  List<ChatMessage> messagesForUser(String userId) {
    final list = _messages.where((m) => m.userId == userId).toList();
    list.sort((a, b) => a.time.compareTo(b.time));
    return list;
  }

  @override
  List<ChatSession> allSessionsSorted() {
    final list = _sessions.values.toList();
    list.sort((a, b) => b.lastTime.compareTo(a.lastTime));
    return list;
  }

  @override
  Future<void> markSessionVisited(String userId, {DateTime? at}) async {
    final existing = _sessions[userId];
    if (existing == null) return;
    _sessions[userId] = existing.copyWith(lastVisited: at ?? DateTime.now());
  }

  @override
  Future<void> upsertSession({required AppUser user, required String lastMessage, required DateTime time}) async {
    final existing = _sessions[user.id];
    if (existing == null) {
      _sessions[user.id] = ChatSession(userId: user.id, userName: user.name, userInitial: user.initial, lastMessage: lastMessage, lastTime: time, lastVisited: DateTime.fromMillisecondsSinceEpoch(0));
    } else {
      _sessions[user.id] = existing.copyWith(lastMessage: lastMessage, lastTime: time);
    }
  }
}

void main() {
  testWidgets('HistoryPage shows unread badge for recent unread messages and hides on tap', (WidgetTester tester) async {
    final repo = TestChatRepo();
    final historyC = HistoryController(repo);

    final now = DateTime.now();
    final userId = 'u-1';

    // Session with last message 5 minutes ago and lastVisited earlier -> should show badge
    final s = ChatSession(
      userId: userId,
      userName: 'Tester',
      userInitial: 'T',
      lastMessage: 'Hello',
      lastTime: now.subtract(const Duration(minutes: 5)),
      lastVisited: now.subtract(const Duration(minutes: 20)),
    );
    repo.addSessionForTest(s);

    // One message 4 minutes ago -> counts as unread
    repo.addMessageForTest(ChatMessage(id: 'm1', userId: userId, text: 'hi', type: MessageType.receiver, time: now.subtract(const Duration(minutes: 4))));

    // Register controller with Get so HistoryPage finds it
    Get.reset();
    Get.put<HistoryController>(historyC);

    await tester.pumpWidget(GetMaterialApp(
      home: Scaffold(body: HistoryPage()),
      getPages: [
        GetPage(name: '/chat', page: () => const Scaffold(body: Center(child: Text('chat')))),
      ],
    ));
    await tester.pumpAndSettle();

    // Badge with '1' should be visible
    expect(find.text('1'), findsOneWidget);

    // Tap the ListTile (open chat) -> this calls markSessionVisited and navigates
    final tileFinder = find.text('Tester');
    expect(tileFinder, findsOneWidget);
    await tester.tap(tileFinder);
    await tester.pumpAndSettle();

    // Badge should disappear
    expect(find.text('1'), findsNothing);
  });
}
