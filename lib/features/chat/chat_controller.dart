import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../data/models/app_user.dart';
import '../../data/models/chat_message.dart';
import '../../data/repos/chat_repo.dart';
import '../../data/services/receiver_api.dart';
import '../history/history_controller.dart';

class ChatController extends GetxController {
  final AppUser user;
  final ChatRepo chatRepo;
  final HistoryController historyC;

  late final ReceiverApi receiverApi;

  ChatController({
    required this.user,
    required this.chatRepo,
    required this.historyC,
  });

  final messages = <ChatMessage>[].obs;
  final isFetching = false.obs;

  @override
  void onInit() {
    super.onInit();
    receiverApi = ReceiverApi(http.Client());
    load();
  }

  void load() {
    messages.value = chatRepo.messagesForUser(user.id);
  }

  Future<void> send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final now = DateTime.now();
    final senderMsg = ChatMessage(
      id: 's_${now.millisecondsSinceEpoch}',
      userId: user.id,
      text: trimmed,
      type: MessageType.sender,
      time: now,
    );

    await chatRepo.addMessage(senderMsg);
    await chatRepo.upsertSession(user: user, lastMessage: trimmed, time: now);
    load();
    historyC.refreshSessions();

    isFetching.value = true;
    try {
      final reply = await receiverApi.fetchRandomReceiverMessage();
      final t = DateTime.now();
      final receiverMsg = ChatMessage(
        id: 'r_${t.millisecondsSinceEpoch}',
        userId: user.id,
        text: reply,
        type: MessageType.receiver,
        time: t,
      );
      await chatRepo.addMessage(receiverMsg);
      await chatRepo.upsertSession(user: user, lastMessage: reply, time: t);
      load();
      historyC.refreshSessions();
    } catch (_) {
      final t = DateTime.now();
      final failMsg = ChatMessage(
        id: 'r_fail_${t.millisecondsSinceEpoch}',
        userId: user.id,
        text: 'Failed to load message. Tap to retry.',
        type: MessageType.receiver,
        time: t,
      );
      await chatRepo.addMessage(failMsg);
      load();
    } finally {
      isFetching.value = false;
    }
  }

  Future<void> retryReceiver() async {
    if (isFetching.value) return;
    isFetching.value = true;
    try {
      final reply = await receiverApi.fetchRandomReceiverMessage();
      final t = DateTime.now();
      final receiverMsg = ChatMessage(
        id: 'r_${t.millisecondsSinceEpoch}',
        userId: user.id,
        text: reply,
        type: MessageType.receiver,
        time: t,
      );
      await chatRepo.addMessage(receiverMsg);
      await chatRepo.upsertSession(user: user, lastMessage: reply, time: t);
      load();
      historyC.refreshSessions();
    } finally {
      isFetching.value = false;
    }
  }
}
