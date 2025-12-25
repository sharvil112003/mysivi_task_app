import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mysivi_task_app/features/chat/widgets/word_bubble.dart';
import 'package:mysivi_task_app/app/utils/app_avatar.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(title: Row(
        mainAxisAlignment: .start,
        // crossAxisAlignment:,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: AppAvatar(
                initials: user.initial,
                radius: 22,
                gradientColors: const [
                  Color(0xFF4F7BFF), // blue
                  Color(0xFF7A4CFF), // purple
                  Color(0xFFB84BFF), // pink-purple
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, fontSize: 20)),
              SizedBox(height: 4),
              Text(
                user.createdAt.second % 2 == 0
                    ? 'Seen today at ${user.createdAt.hour}:${user.createdAt.minute}'
                    : 'Online',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 15, color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),backgroundColor: Colors.white,shape: Border.all(
        color: Colors.grey.shade300,
        width: 2,
      ),),
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
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text('Typing...', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14, color: Colors.grey.shade700)),
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
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.blue.withOpacity(0.25)),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 10,
                  offset: Offset(0, 4),
                  color: Colors.black12,
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                  onPressed: () {},
                  icon: Icon(Icons.emoji_emotions_outlined, color: Colors.blue.withOpacity(0.75)),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: TextField(
                    controller: inputC,
                    minLines: 1,
                    maxLines: 5,
                    textInputAction: TextInputAction.send,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: Theme.of(context).inputDecorationTheme.hintStyle ?? Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16, color: Colors.grey.shade600),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                  onPressed: () {},
                  icon: Icon(Icons.attach_file, color: Colors.blue.withOpacity(0.75)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: _send,
          child: Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                LucideIcons.sendHorizontal,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
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
