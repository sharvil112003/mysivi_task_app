import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mysivi_task_app/features/history/history_page.dart';
import 'package:mysivi_task_app/features/history/history_controller.dart';
import 'package:mysivi_task_app/features/chat/chat_controller.dart';
import 'package:mysivi_task_app/data/repos/chat_repo.dart';
import 'package:mysivi_task_app/data/models/chat_message.dart';
import 'package:mysivi_task_app/data/models/app_user.dart';
import 'package:mysivi_task_app/data/models/chat_session.dart';
import 'package:mysivi_task_app/data/services/receiver_api.dart';
import 'package:http/http.dart' as http;

class TestChatRepo extends ChatRepo {
  final List<ChatMessage> _messages = [];
  final Map<String, ChatSession> _sessions = {};

  void addMessageForTest(ChatMessage m) {
    _messages.add(m);
  }

  @override
  List<ChatMessage> messagesForUser(String userId) {
    final list = _messages.where((m) => m.userId == userId).toList();
    list.sort((a, b) => a.time.compareTo(b.time));
    return list;
  }

  @override
  Future<void> addMessage(ChatMessage message) async {
    _messages.add(message);
  }

  @override
  List<ChatSession> allSessionsSorted() {
    final list = _sessions.values.toList();
    list.sort((a, b) => b.lastTime.compareTo(a.lastTime));
    return list;
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

  @override
  Future<void> markSessionVisited(String userId, {DateTime? at}) async {
    final existing = _sessions[userId];
    if (existing == null) return;
    _sessions[userId] = existing.copyWith(lastVisited: at ?? DateTime.now());
  }
}

class FakeReceiverApi extends ReceiverApi {
  final String reply;
  FakeReceiverApi(this.reply) : super(http.Client());

  @override
  Future<String> fetchRandomReceiverMessage() async => reply;
}

void main() {
  testWidgets('Sending message updates history and shows unread badge', (WidgetTester tester) async {
    final repo = TestChatRepo();
    final historyC = HistoryController(repo);

    final user = AppUser(id: 'u-1', name: 'Tester', createdAt: DateTime.now());
    final chatC = ChatController(user: user, chatRepo: repo, historyC: historyC);
      // inject fake receiver
    chatC.receiverApi = FakeReceiverApi('reply');

    // register controllers
    Get.reset();
    Get.put<HistoryController>(historyC);

    await tester.pumpWidget(GetMaterialApp(
      home: Scaffold(body: HistoryPage()),
      getPages: [
        GetPage(name: '/chat', page: () => const Scaffold(body: Center(child: Text('chat')))),
      ],
    ));

    await tester.pumpAndSettle();

    // No sessions yet -> no badge
    expect(find.text('1'), findsNothing);

    // Send message via chat controller
    await chatC.send('hello');
    // refresh sessions to simulate what the app does
    historyC.refreshSessions();

    await tester.pumpAndSettle();

    // Controller should report one recent unread message
    expect(historyC.recentMessageCount(user.id), 1);

    // Open the chat (tap title) to mark visited and navigate
    await tester.tap(find.text('Tester'));
    await tester.pumpAndSettle();

    // After visiting, controller reports 0
    expect(historyC.recentMessageCount(user.id), 0);
  });
}
