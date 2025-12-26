import 'package:get/get.dart';
import '../../data/models/chat_session.dart';
import '../../data/repos/chat_repo.dart';
import '../../data/models/chat_message.dart';

class HistoryController extends GetxController {
  final ChatRepo repo;
  HistoryController(this.repo);

  final sessions = <ChatSession>[].obs;

  @override
  void onInit() {
    super.onInit();
    refreshSessions();
  }

  void refreshSessions() {
    sessions.value = repo.allSessionsSorted();
  }

  int recentMessageCount(String userId, {Duration window = const Duration(minutes: 10)}) {
    final msgs = repo.messagesForUser(userId);
    final now = DateTime.now();
    final session = repo.allSessionsSorted().firstWhere((s) => s.userId == userId, orElse: () => ChatSession(userId: userId, userName: '', userInitial: '', lastMessage: '', lastTime: DateTime.fromMillisecondsSinceEpoch(0), lastVisited: DateTime.fromMillisecondsSinceEpoch(0)));
    final cutoff = now.subtract(window);
    return msgs.where((m) => m.type == MessageType.receiver && m.time.isAfter(session.lastVisited) && m.time.isAfter(cutoff)).length;
  }

  Future<void> markSessionVisited(String userId) async {
    await repo.markSessionVisited(userId);
    refreshSessions();
  }
}
