import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysivi_task_app/app/routes/routes.dart';
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
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final AppUser u = users[i];
          return ListTile(
            leading: CircleAvatar(child: Text(u.initial)),
            title: Text(u.name),
            onTap: () => Get.toNamed(Routes.chat, arguments: u),
          );
        },
      );
    });
  }
}
