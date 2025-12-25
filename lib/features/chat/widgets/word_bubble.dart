import 'package:flutter/material.dart';
import 'package:mysivi_task_app/app/utils/app_avatar.dart';
import 'package:mysivi_task_app/features/chat/widgets/word_wrap_text.dart';
import '../../../data/models/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isSender;
  final String avatarInitial;
  final VoidCallback? onTap;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isSender,
    required this.avatarInitial,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16);
    final bubbleColor = isSender ? Colors.blue.shade100 : Colors.grey.shade200;

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isSender) AppAvatar(initials: avatarInitial, radius: 14, textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              
              if (!isSender) const SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(color: bubbleColor, borderRadius: radius),
                  child: WordTapText(
                    text: message.text,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
                  ),
                ),
              ),
              if (isSender) const SizedBox(width: 8),
              if (isSender) AppAvatar(initials: avatarInitial, radius: 14, textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}
