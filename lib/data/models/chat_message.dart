enum MessageType { sender, receiver }

class ChatMessage {
  final String id;
  final String userId;
  final String text;
  final MessageType type;
  final DateTime time;

  ChatMessage({
    required this.id,
    required this.userId,
    required this.text,
    required this.type,
    required this.time,
  });
}
