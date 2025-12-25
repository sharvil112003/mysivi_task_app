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
}
