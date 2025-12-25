import 'package:flutter_test/flutter_test.dart';
import 'package:mysivi_task_app/features/chat/chat_controller.dart';
import 'package:mysivi_task_app/features/history/history_controller.dart';
import 'package:mysivi_task_app/data/repos/chat_repo.dart';
import 'package:mysivi_task_app/data/models/chat_message.dart';
import 'package:mysivi_task_app/data/models/app_user.dart';
import 'package:mysivi_task_app/data/models/chat_session.dart';
import 'package:mysivi_task_app/data/services/receiver_api.dart';
import 'package:http/http.dart' as http;

class TestChatRepo extends ChatRepo {
  final List<ChatMessage> _messages = [];
  final Map<String, ChatSession> _sessions = {};

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
  test('ChatController send() adds sender and receiver messages and updates session', () async {
    final repo = TestChatRepo();
    final historyC = HistoryController(repo);

    final user = AppUser(id: 'u1', name: 'Test', createdAt: DateTime.now());
    final chatC = ChatController(user: user, chatRepo: repo, historyC: historyC);

    // inject fake receiver API
    chatC.receiverApi = FakeReceiverApi('ok') as dynamic;

    await chatC.send('hello');

    final msgs = repo.messagesForUser(user.id);
    expect(msgs.length, 2);
    expect(msgs.first.text, 'hello');
    expect(msgs.last.text, 'ok');

    // session should be updated with last message 'ok'
    final sessions = repo.allSessionsSorted();
    expect(sessions.isNotEmpty, true);
    final session = sessions.first;
    expect((session as dynamic).lastMessage, 'ok');
  });
}
