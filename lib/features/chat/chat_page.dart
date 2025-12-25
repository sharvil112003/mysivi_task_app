import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysivi_task_app/features/chat/widgets/word_bubble.dart';
import '../../data/models/app_user.dart';
import '../../data/repos/chat_repo.dart';
import '../history/history_controller.dart';
import 'chat_controller.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final AppUser user;
  late final ChatController c;

  final inputC = TextEditingController();
  final scrollC = ScrollController();

  @override
  void initState() {
    super.initState();
    user = Get.arguments as AppUser;

    final historyC = Get.find<HistoryController>();

    c = Get.put(
      ChatController(
        user: user,
        chatRepo: ChatRepo(),
        historyC: historyC,
      ),
      tag: user.id,
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollC.hasClients) return;
      scrollC.animateTo(
        scrollC.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  void _send() async {
    final text = inputC.text;
    inputC.clear();
    await c.send(text);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user.name)),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final msgs = c.messages;
              final extra = c.isFetching.value ? 1 : 0;

              return ListView.builder(
                controller: scrollC,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                itemCount: msgs.length + extra,
                itemBuilder: (_, i) {
                  if (c.isFetching.value && i == msgs.length) {
                    return const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text('Typing...'),
                      ),
                    );
                  }

                  final m = msgs[i];
                  final isSender = m.type.name == 'sender';

                  return MessageBubble(
                    message: m,
                    isSender: isSender,
                    avatarInitial: isSender ? 'Y' : user.initial,
                    onTap: () {
                      if (!isSender && m.text.startsWith('Failed to load')) {
                        c.retryReceiver();
                      }
                    },
                  );
                },
              );
            }),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: inputC,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _send,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
