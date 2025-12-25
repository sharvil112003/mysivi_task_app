import 'package:hive/hive.dart';
import '../models/app_user.dart';
import '../models/chat_message.dart';
import '../models/chat_session.dart';

class AppUserAdapter extends TypeAdapter<AppUser> {
  @override
  final int typeId = 1;

  @override
  AppUser read(BinaryReader reader) {
    final id = reader.readString();
    final name = reader.readString();
    final createdAtMillis = reader.readInt();
    return AppUser(
      id: id,
      name: name,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtMillis),
    );
  }

  @override
  void write(BinaryWriter writer, AppUser obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeInt(obj.createdAt.millisecondsSinceEpoch);
  }
}

class MessageTypeAdapter extends TypeAdapter<MessageType> {
  @override
  final int typeId = 2;

  @override
  MessageType read(BinaryReader reader) {
    final index = reader.readInt();
    return MessageType.values[index];
  }

  @override
  void write(BinaryWriter writer, MessageType obj) {
    writer.writeInt(obj.index);
  }
}

class ChatMessageAdapter extends TypeAdapter<ChatMessage> {
  @override
  final int typeId = 3;

  @override
  ChatMessage read(BinaryReader reader) {
    final id = reader.readString();
    final userId = reader.readString();
    final text = reader.readString();
    final type = reader.read() as MessageType;
    final timeMillis = reader.readInt();
    return ChatMessage(
      id: id,
      userId: userId,
      text: text,
      type: type,
      time: DateTime.fromMillisecondsSinceEpoch(timeMillis),
    );
  }

  @override
  void write(BinaryWriter writer, ChatMessage obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.userId);
    writer.writeString(obj.text);
    writer.write(obj.type);
    writer.writeInt(obj.time.millisecondsSinceEpoch);
  }
}

class ChatSessionAdapter extends TypeAdapter<ChatSession> {
  @override
  final int typeId = 4;

  @override
  ChatSession read(BinaryReader reader) {
    final userId = reader.readString();
    final userName = reader.readString();
    final userInitial = reader.readString();
    final lastMessage = reader.readString();
    final lastTimeMillis = reader.readInt();

    return ChatSession(
      userId: userId,
      userName: userName,
      userInitial: userInitial,
      lastMessage: lastMessage,
      lastTime: DateTime.fromMillisecondsSinceEpoch(lastTimeMillis),
    );
  }

  @override
  void write(BinaryWriter writer, ChatSession obj) {
    writer.writeString(obj.userId);
    writer.writeString(obj.userName);
    writer.writeString(obj.userInitial);
    writer.writeString(obj.lastMessage);
    writer.writeInt(obj.lastTime.millisecondsSinceEpoch);
  }
}
