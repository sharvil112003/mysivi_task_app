import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysivi_task_app/app/routes/routes.dart';
import 'package:mysivi_task_app/app/utils/app_avatar.dart';
import '../../data/models/app_user.dart';
import 'users_controller.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> with AutomaticKeepAliveClientMixin {
  final usersC = Get.find<UsersController>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Obx(() {
      final users = usersC.users;
      if (users.isEmpty) {
        return const Center(child: Text('No users yet. Tap + to add one.'));
      }

      return ListView.separated(
        key: const PageStorageKey('users_list'),
        itemCount: users.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final AppUser u = users[i];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: AppAvatar(
  radius: 22,
  backgroundColor: Colors.transparent,
  child: Container(
    width: 44,
    height: 44,
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
        u.initial,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
    ),
  ),
),

            title: Text(u.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, fontSize: 18)),
            subtitle: (u.createdAt.second%2 == 0) ? Text('Last seen ${DateTime.now().difference(u.createdAt)}') : Text('Online'),
            onTap: () => Get.toNamed(Routes.chat, arguments: u),
          );
        },
      );
    });
  }
}
