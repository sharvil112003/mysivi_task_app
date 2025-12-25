import '../hive/hive_service.dart';
import '../models/app_user.dart';
import '../models/chat_message.dart';
import '../models/chat_session.dart';

class ChatRepo {
  List<ChatMessage> messagesForUser(String userId) {
    final box = HiveService.messagesBox();
    final list = box.values.where((m) => m.userId == userId).toList();
    list.sort((a, b) => a.time.compareTo(b.time));
    return list;
  }

  Future<void> addMessage(ChatMessage message) async {
    await HiveService.messagesBox().put(message.id, message);
  }

  List<ChatSession> allSessionsSorted() {
    final box = HiveService.sessionsBox();
    final list = box.values.toList();
    list.sort((a, b) => b.lastTime.compareTo(a.lastTime));
    return list;
  }

  Future<void> upsertSession({
    required AppUser user,
    required String lastMessage,
    required DateTime time,
  }) async {
    final box = HiveService.sessionsBox();
    final existing = box.get(user.id);
    if (existing == null) {
      final session = ChatSession(
        userId: user.id,
        userName: user.name,
        userInitial: user.initial,
        lastMessage: lastMessage,
        lastTime: time,
      );
      await box.put(user.id, session);
    } else {
      await box.put(user.id, existing.copyWith(lastMessage: lastMessage, lastTime: time));
    }
  }
}
