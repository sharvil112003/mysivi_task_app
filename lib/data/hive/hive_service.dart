import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../app/hive_keys.dart';
import '../models/app_user.dart';
import '../models/chat_message.dart';
import '../models/chat_session.dart';
import 'adapters.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(AppUserAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(MessageTypeAdapter());
    if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(ChatMessageAdapter());
    if (!Hive.isAdapterRegistered(4)) Hive.registerAdapter(ChatSessionAdapter());

    await Hive.openBox<AppUser>(HiveKeys.usersBox);
    await Hive.openBox<ChatSession>(HiveKeys.sessionsBox);
    await Hive.openBox<ChatMessage>(HiveKeys.messagesBox);
  }

  static Box<AppUser> usersBox() => Hive.box<AppUser>(HiveKeys.usersBox);
  static Box<ChatSession> sessionsBox() => Hive.box<ChatSession>(HiveKeys.sessionsBox);
  static Box<ChatMessage> messagesBox() => Hive.box<ChatMessage>(HiveKeys.messagesBox);
}
