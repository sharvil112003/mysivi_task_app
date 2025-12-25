class ChatSession {
  final String userId;
  final String userName;
  final String userInitial;
  final String lastMessage;
  final DateTime lastTime;

  ChatSession({
    required this.userId,
    required this.userName,
    required this.userInitial,
    required this.lastMessage,
    required this.lastTime,
  });

  ChatSession copyWith({
    String? lastMessage,
    DateTime? lastTime,
  }) {
    return ChatSession(
      userId: userId,
      userName: userName,
      userInitial: userInitial,
      lastMessage: lastMessage ?? this.lastMessage,
      lastTime: lastTime ?? this.lastTime,
    );
  }
}
