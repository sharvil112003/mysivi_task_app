import 'package:get/get.dart';
import '../../data/models/chat_session.dart';
import '../../data/repos/chat_repo.dart';

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

  /// Returns the number of messages for [userId] within the given [window]
  /// and that were sent *after* the session's lastVisited time (i.e., unread).
  int recentMessageCount(String userId, {Duration window = const Duration(minutes: 10)}) {
    final msgs = repo.messagesForUser(userId);
    final now = DateTime.now();
    final session = repo.allSessionsSorted().firstWhere((s) => s.userId == userId, orElse: () => ChatSession(userId: userId, userName: '', userInitial: '', lastMessage: '', lastTime: DateTime.fromMillisecondsSinceEpoch(0), lastVisited: DateTime.fromMillisecondsSinceEpoch(0)));
    final cutoff = now.subtract(window);
    return msgs.where((m) => m.time.isAfter(session.lastVisited) && m.time.isAfter(cutoff)).length;
  }

  /// Mark a session as visited (messages before this time count as read).
  Future<void> markSessionVisited(String userId) async {
    await repo.markSessionVisited(userId);
    refreshSessions();
  }
}
