import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysivi_task_app/app/routes/routes.dart';
import 'package:mysivi_task_app/app/utils/app_avatar.dart';
import 'package:mysivi_task_app/app/utils/time_utils.dart';
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
        padding: EdgeInsets.zero,
        itemCount: sessions.length,
        separatorBuilder: (_, __) => const SizedBox.shrink(),
        itemBuilder: (_, i) {
          final s = sessions[i];
          final now = DateTime.now();
          final showCount = now.difference(s.lastTime) <= const Duration(minutes: 10);
          final recentCount = showCount ? historyC.recentMessageCount(s.userId) : 0;
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: AppAvatar(
              initials: s.userInitial,
              radius: 22,
              gradientColors: const [
                Color.fromARGB(255, 92, 219, 173), // bright teal
                Color.fromARGB(255, 84, 209, 190), // teal
                Color.fromARGB(255, 11, 150, 74), // green
              ],
            ),
            title: Text(s.userName, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, fontSize: 18)),
            subtitle: Text(s.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(formatRelativeTime(s.lastTime)),
                if (recentCount > 0) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFF2769FC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$recentCount',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ],
            ),
            onTap: () async {
              // Mark as visited so unread/recent badge disappears.
              await historyC.markSessionVisited(s.userId);
              final u = AppUser(id: s.userId, name: s.userName, createdAt: DateTime.now());
              Get.toNamed(Routes.chat, arguments: u);
            },

          );
        },
      );
    });
  }
}
