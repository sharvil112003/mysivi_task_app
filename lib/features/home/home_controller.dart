import 'package:get/get.dart';

class HomeController extends GetxController {
  final tabIndex = 0.obs; // 0 Users, 1 History
  void setTab(int i) => tabIndex.value = i;
}
