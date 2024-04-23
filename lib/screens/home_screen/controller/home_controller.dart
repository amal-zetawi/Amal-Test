import 'package:Talabat/sql/db_helper.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt currentPageIndex = 0.obs;
  RxList users = [].obs;
  var currentTabIndex = 0.obs;

  // Method to update the current tab index
  void updateCurrentTabIndex(int index) {
    currentTabIndex.value = index;
  }

  getUsers(String table) async {
    List<Map> response = await DatabaseHelper.read(table);
    users.addAll(response);
  }

  Future<List<Map<String, dynamic>>?> getItem() async {
    // Fetch items when the screen initializes
   return await DatabaseHelper.getAllItems();
  }

  Future<void> updateItem(int index) async {
   // await DatabaseHelper.updateItem(index);
    // Notify listeners to trigger a rebuild
    update();
  }

  Future<void> changePage(int index) async {
    // Update current page index
    currentPageIndex.value = index;
  }
  @override
  void onInit() {
    super.onInit();
    currentTabIndex.value = Get.arguments ?? 0;
    getUsers('users');
  }

}