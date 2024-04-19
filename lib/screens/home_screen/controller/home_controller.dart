import 'package:Talabat/sql/db_helper.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt currentPageIndex = 0.obs;

  Future<List<Map<String, dynamic>>?> getItem() async {
    // Fetch items when the screen initializes
   return await DatabaseHelper.getAllItems();
  }

  Future<void> deleteItem(int index) async {
    await DatabaseHelper.deleteItem(index);
    // Notify listeners to trigger a rebuild
    update();
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


}