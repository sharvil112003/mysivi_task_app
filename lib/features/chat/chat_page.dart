import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mysivi_task_app/app/utils/time_utils.dart';
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

  void _showUserInfo() {
    showDialog(
      context: context,
      builder: (ctx) {
        final mq = MediaQuery.of(ctx).size;
        final dialogWidth = mq.width * 0.9;

        return AlertDialog(
          contentPadding: const EdgeInsets.all(16),
          insetPadding: EdgeInsets.symmetric(horizontal: (mq.width - dialogWidth) / 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: SizedBox(
            width: dialogWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppAvatar(initials: user.initial, radius: 36 * (mq.width / 360), gradientColors: const [Color(0xFF4F7BFF), Color(0xFF7A4CFF), Color(0xFFB84BFF)]),
                const SizedBox(height: 12),
                Text(user.name, style: Theme.of(ctx).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text('Last seen ${formatRelativeTime(user.createdAt)}', style: Theme.of(ctx).textTheme.bodySmall),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Close'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: user.id));
                        Navigator.of(ctx).pop();
                        Get.snackbar('Copied', 'User ID copied to clipboard', snackPosition: SnackPosition.TOP);
                      },
                      child: const Text('Copy ID'),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final scale = mq.size.width / 360;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Row(
        mainAxisAlignment: .start,
        // crossAxisAlignment:,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0 * scale),
            child: Padding(
              padding: EdgeInsets.all(0),
              child: GestureDetector(
                onTap: _showUserInfo,
                child: AppAvatar(
                  initials: user.initial,
                  radius: 22 * scale,
                  isOnline: (user.createdAt.second % 2 != 0),
                  gradientColors: const [
                    Color(0xFF4F7BFF), // blue
                    Color(0xFF7A4CFF), // purple
                    Color(0xFFB84BFF), // pink-purple
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 12 * scale),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, fontSize: 20 * scale)),
              SizedBox(height: 4 * scale),
              Text(
                user.createdAt.second % 2 == 0
                    ? 'Seen ${formatRelativeTime(user.createdAt)}'
                    : 'Online',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 15 * scale, color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),backgroundColor: Colors.white,shape: Border.all(
        color: Colors.grey.shade300,
        width: 2 * scale,
      ),),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final msgs = c.messages;
              final extra = c.isFetching.value ? 1 : 0;

              return ListView.builder(
                controller: scrollC,
                padding: EdgeInsets.symmetric(vertical: 12 * scale, horizontal: 12 * scale),
                itemCount: msgs.length + extra,
                itemBuilder: (_, i) {
                  if (c.isFetching.value && i == msgs.length) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 8 * scale),
                        child: Text('Typing...', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14 * scale, color: Colors.grey.shade700)),
                      ),
                    );
                  }

                  final m = msgs[i];
                  final isSender = m.type.name == 'sender';

                  return Padding(
                    padding: EdgeInsets.all(10.0 * scale),
                    child: Column(
                      children: [
                        MessageBubble(
                          message: m,
                          isSender: isSender,
                          avatarInitial: isSender ? 'Y' : user.initial,
                          onTap: () {
                            if (!isSender && m.text.startsWith('Failed to load')) {
                              c.retryReceiver();
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
          SafeArea(
  top: false,
  child: Padding(
    padding: EdgeInsets.fromLTRB(12 * scale, 8 * scale, 12 * scale, 12 * scale),
    child: Row(
      children: [ 
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12 * scale, vertical: 6 * scale),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28 * scale),
              border: Border.all(color: const Color(0xFF2769FC).withOpacity(0.25)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10 * scale,
                  offset: Offset(0, 4 * scale),
                  color: Colors.black12,
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(minWidth: 36 * scale, minHeight: 36 * scale),
                  onPressed: () {},
                  icon: Icon(Icons.emoji_emotions_outlined, color: const Color(0xFF2769FC).withOpacity(0.75)),
                ),
                SizedBox(width: 6 * scale),
                Expanded(
                  child: TextField(
                    controller: inputC,
                    minLines: 1,
                    maxLines: 5,
                    textInputAction: TextInputAction.send,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: Theme.of(context).inputDecorationTheme.hintStyle ?? Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16 * scale, color: Colors.grey.shade600),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(minWidth: 36 * scale, minHeight: 36 * scale),
                  onPressed: () {},
                  icon: Icon(Icons.attach_file, color: const Color(0xFF2769FC).withOpacity(0.75)),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 10 * scale),
        GestureDetector(
          onTap: _send,
          child: Container(
            width: 48 * scale,
            height: 48 * scale,
            decoration: const BoxDecoration(
              color: Color(0xFF2769FC),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                LucideIcons.sendHorizontal,
                color: Colors.white,
                size: 22 * scale,
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
