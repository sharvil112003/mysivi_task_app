import 'package:flutter_test/flutter_test.dart';
import 'package:mysivi_task_app/features/history/history_controller.dart';
import 'package:mysivi_task_app/data/models/chat_message.dart';
import 'package:mysivi_task_app/data/models/chat_session.dart';
import 'package:mysivi_task_app/data/models/app_user.dart';
import 'package:mysivi_task_app/data/repos/chat_repo.dart';

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
  Future<void> upsertSession({required AppUser user, required String lastMessage, required DateTime time}) async {
    final existing = _sessions[user.id];
    if (existing == null) {
      _sessions[user.id] = ChatSession(
        userId: user.id,
        userName: user.name,
        userInitial: user.initial,
        lastMessage: lastMessage,
        lastTime: time,
        lastVisited: DateTime.fromMillisecondsSinceEpoch(0),
      );
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

void main() {
  group('HistoryController.recentMessageCount', () {
    test('counts only messages within 10 minutes and after lastVisited', () {
      final repo = TestChatRepo();
      final controller = HistoryController(repo);

      final now = DateTime.now();
      final userId = 'user1';

      // session lastVisited 20 minutes ago
      final session = ChatSession(
        userId: userId,
        userName: 'Alice',
        userInitial: 'A',
        lastMessage: 'hi',
        lastTime: now.subtract(const Duration(minutes: 20)),
        lastVisited: now.subtract(const Duration(minutes: 20)),
      );
      repo.addSessionForTest(session);

      // message 5 minutes ago -> should count
      repo.addMessageForTest(ChatMessage(id: 'm1', userId: userId, text: 'recent', type: MessageType.receiver, time: now.subtract(const Duration(minutes: 5))));

      // message 15 minutes ago -> too old
      repo.addMessageForTest(ChatMessage(id: 'm2', userId: userId, text: 'old', type: MessageType.receiver, time: now.subtract(const Duration(minutes: 15))));

      final count = controller.recentMessageCount(userId);
      expect(count, 1);
    });

    test('does not count messages older than lastVisited', () async {
      final repo = TestChatRepo();
      final controller = HistoryController(repo);

      final now = DateTime.now();
      final userId = 'user2';

      final session = ChatSession(
        userId: userId,
        userName: 'Bob',
        userInitial: 'B',
        lastMessage: 'hey',
        lastTime: now,
        lastVisited: now.subtract(const Duration(minutes: 2)),
      );
      repo.addSessionForTest(session);

      // message 1 minute ago (after lastVisited) -> should count 1
      repo.addMessageForTest(ChatMessage(id: 'm1', userId: userId, text: 'after', type: MessageType.receiver, time: now.subtract(const Duration(minutes: 1))));

      // message 3 minutes ago (before lastVisited) -> should not count
      repo.addMessageForTest(ChatMessage(id: 'm2', userId: userId, text: 'before', type: MessageType.receiver, time: now.subtract(const Duration(minutes: 3))));

      final count1 = controller.recentMessageCount(userId);
      expect(count1, 1);

      // Mark visited now, count should be 0
      await controller.markSessionVisited(userId);
      final count2 = controller.recentMessageCount(userId);
      expect(count2, 0);
    });
  });
}
