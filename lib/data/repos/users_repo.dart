import '../hive/hive_service.dart';
import '../models/app_user.dart';

class UsersRepo {
  List<AppUser> getAll() {
    final box = HiveService.usersBox();
    final list = box.values.toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  Future<void> add(AppUser user) async {
    await HiveService.usersBox().put(user.id, user);
  }
}
