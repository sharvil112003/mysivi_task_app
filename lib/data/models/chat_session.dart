class ChatSession {
  final String userId;
  final String userName;
  final String userInitial;
  final String lastMessage;
  final DateTime lastTime;
  final DateTime lastVisited;

  ChatSession({
    required this.userId,
    required this.userName,
    required this.userInitial,
    required this.lastMessage,
    required this.lastTime,
    required this.lastVisited,
  });

  ChatSession copyWith({
    String? lastMessage,
    DateTime? lastTime,
    DateTime? lastVisited,
  }) {
    return ChatSession(
      userId: userId,
      userName: userName,
      userInitial: userInitial,
      lastMessage: lastMessage ?? this.lastMessage,
      lastTime: lastTime ?? this.lastTime,
      lastVisited: lastVisited ?? this.lastVisited,
    );
  }
}
