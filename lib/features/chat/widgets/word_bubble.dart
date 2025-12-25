import 'package:flutter/material.dart';
import 'package:mysivi_task_app/app/utils/app_avatar.dart';
import 'package:mysivi_task_app/app/utils/time_utils.dart';
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
    final mq = MediaQuery.of(context);
    final scale = mq.size.width / 360;
    final radius = Radius.circular(16 * scale);
    final bubbleColor = isSender ? const Color(0xFF2769FC) : Colors.grey.shade200;

    // Responsive measurements
    final avatarRadius = 22 * scale;
    final avatarDiameter = avatarRadius * 2;
    final horizontalSpacing = 8 * scale;
    final verticalPadding = 6 * scale;
    final bubblePaddingHorizontal = 12 * scale;
    final bubblePaddingVertical = 10 * scale;
    final timestampFontSize = 12 * scale;
    final avatarFontSize = 18 * scale;
    final maxBubbleWidth = mq.size.width * 0.5;

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          child: Row(
            mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isSender) AppAvatar(
  radius: avatarRadius,
  backgroundColor: Colors.transparent,
  child: Container(
    width: avatarDiameter,
    height: avatarDiameter,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF4F7BFF), // blue
          Color(0xFF7A4CFF), // purple
          Color(0xFFB84BFF), // pink-purple
        ],
        stops: [0.0, 0.55, 1.0],
      ),
    ),
    child: Center(
      child: Text(
        avatarInitial,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: avatarFontSize,
        ),
      ),
    ),
  ),
),
              
              if (!isSender) SizedBox(width: horizontalSpacing),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: maxBubbleWidth),
                      padding: EdgeInsets.symmetric(horizontal: bubblePaddingHorizontal, vertical: bubblePaddingVertical),
                      decoration: BoxDecoration(
                        color: bubbleColor,
                        borderRadius: isSender
                            ? BorderRadius.only(topLeft: radius, bottomLeft: radius, bottomRight: radius)
                            : BorderRadius.only(topRight: radius, bottomLeft: radius, bottomRight: radius),
                      ),
                      child: WordTapText(
                        text: message.text,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: isSender ? Colors.white : Colors.black),
                      ),
                    ),
                    SizedBox(height: 4 * scale),
                    Text(
                      formatExactTime(message.time),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.black54,
                        fontSize: timestampFontSize,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSender) SizedBox(width: horizontalSpacing),
              if (isSender) AppAvatar(
  radius: avatarRadius,
  backgroundColor: Colors.transparent,
  child: Container(
    width: avatarDiameter,
    height: avatarDiameter,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFC549E0),
    Color(0xFFD54BCC),
    Color.fromARGB(255, 217, 55, 115), // pink-purple
        ],
        stops: [0.0, 0.55, 1.0],
      ),
    ),
    child: Center(
      child: Text(
        avatarInitial,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: avatarFontSize,
        ),
      ),
    ),
  ),
),
            ],
          ),
        ),
      ),
    );
  }
}
