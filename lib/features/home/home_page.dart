import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysivi_task_app/app/utils/custom_snackbar.dart';
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
        backgroundColor: Colors.white,
        floatingActionButton: homeC.tabIndex.value == 0
            ? FloatingActionButton(
              backgroundColor: const Color(0xFF2769FC),
              shape: const CircleBorder(),
                onPressed: () async {
                  final name = await showAddUserDialog(context);
                  if (name == null) return;
                  await usersC.addUser(name);
                  CustomSnackbar.show(
                    title: 'User added',
                    message: name,
                    type: AppSnackType.success,
                  );
                },
                child: const Icon(Icons.add,color: Colors.white,),
              )
            : null,
        body: NestedScrollView(
          headerSliverBuilder: (_, _) {
            return [
              SliverAppBar(
                backgroundColor: Colors.white,
                floating: true,
                snap: true,
                title: Center(
                  child: SegmentedSwitcher(
                    leftLabel: 'Users',
                    rightLabel: 'Chat History',
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
