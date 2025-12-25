import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repos/chat_repo.dart';
import '../../data/repos/users_repo.dart';
import '../history/history_controller.dart';
import '../history/history_page.dart';
import '../users/users_controller.dart';
import '../users/users_page.dart';
import '../users/add_user_dialog.dart';
import 'home_controller.dart';
import 'widgets/segmented_switcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController tabController;
  final homeC = Get.put(HomeController());

  @override
  void initState() {
    super.initState();

    if (!Get.isRegistered<UsersController>()) {
      Get.put(UsersController(UsersRepo()));
    }
    if (!Get.isRegistered<HistoryController>()) {
      Get.put(HistoryController(ChatRepo()));
    }

    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      if (tabController.indexIsChanging) return;
      homeC.setTab(tabController.index);
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usersC = Get.find<UsersController>();

    return Obx(() {
      return Scaffold(
        floatingActionButton: homeC.tabIndex.value == 0
            ? FloatingActionButton(
                onPressed: () async {
                  final name = await showAddUserDialog(context);
                  if (name == null) return;
                  await usersC.addUser(name);
                  Get.snackbar(
                    'User added',
                    name,
                    snackPosition: SnackPosition.BOTTOM,
                    margin: const EdgeInsets.all(12),
                  );
                },
                child: const Icon(Icons.add),
              )
            : null,
        body: NestedScrollView(
          headerSliverBuilder: (_, __) {
            return [
              SliverAppBar(
                floating: true,
                snap: true,
                title: Center(
                  child: SegmentedSwitcher(
                    leftLabel: 'Users',
                    rightLabel: 'History',
                    index: homeC.tabIndex.value,
                    onChanged: (i) {
                      homeC.setTab(i);
                      tabController.animateTo(i);
                    },
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: tabController,
            children: const [
              UsersPage(),
              HistoryPage(),
            ],
          ),
        ),
      );
    });
  }
}
