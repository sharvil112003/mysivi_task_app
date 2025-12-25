import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mysivi_task_app/app/routes/routes.dart';
import '../../data/models/app_user.dart';
import 'history_controller.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> with AutomaticKeepAliveClientMixin {
  final historyC = Get.find<HistoryController>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Obx(() {
      final sessions = historyC.sessions;
      if (sessions.isEmpty) return const Center(child: Text('No chats yet.'));

      return ListView.separated(
        key: const PageStorageKey('history_list'),
        itemCount: sessions.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final s = sessions[i];
          return ListTile(
            leading: CircleAvatar(child: Text(s.userInitial)),
            title: Text(s.userName),
            subtitle: Text(s.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Text(DateFormat('hh:mm a').format(s.lastTime)),
            onTap: () {
              final u = AppUser(id: s.userId, name: s.userName, createdAt: DateTime.now());
              Get.toNamed(Routes.chat, arguments: u);
            },
          );
        },
      );
    });
  }
}
