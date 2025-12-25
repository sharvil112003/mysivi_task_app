import 'package:get/get.dart';
import '../../data/models/app_user.dart';
import '../../data/repos/users_repo.dart';

class UsersController extends GetxController {
  final UsersRepo repo;
  UsersController(this.repo);

  final users = <AppUser>[].obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  void load() {
    users.value = repo.getAll();
  }

  Future<void> addUser(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;

    final user = AppUser(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: trimmed,
      createdAt: DateTime.now(),
    );

    await repo.add(user);
    load();
  }
}
