import 'dart:io';
import 'package:Talabat/routes/app_routes.dart';
import 'package:Talabat/screens/sign_up_screen/models/model_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:Talabat/sql/db_helper.dart';

class SignUpController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  RxList users = [].obs;
  RxInt deletedIndex = 0.obs;

  //
  Rx<String?> profileImage = Rx<String?>(null);

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage.value = (pickedFile.path);
    } else {
      Get.snackbar('Error', 'No image selected.', colorText: Colors.red);
    }
  }
//

  Future<void> signUp() async {
    if (nameController.text.isEmpty ||
        usernameController.text.isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields.',
          colorText: Colors.red);
      return;
    }

    final username = usernameController.text;
    final isUnique = await DatabaseHelper.isUsernameUnique(username);
    if (!isUnique) {
      Get.snackbar(
          'Error', 'Username already exists. Please choose a different one.',
          colorText: Colors.red);
      return;
    }

    final password = passwordController.text;
    bool isPasswordValid(String password) {
      final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');
      return passwordRegex.hasMatch(password);
    }

    if (!isPasswordValid(password)) {
      Get.snackbar('Error',
          'Password must contain at least one uppercase letter, one lowercase letter, one digit, and have a minimum length of 8 characters.',
          colorText: Colors.red);
      return;
    }

    if (profileImage.value == null) {
      Get.snackbar('Error', 'Please select a profile image.',
          colorText: Colors.red);
      return;
    }

    final String profileImagePath = profileImage.value!;
    final File sourceFile = File(profileImagePath);
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String uniqueFileName =
        '${DateTime.now().millisecondsSinceEpoch}_image.png';
    final String profileImageU = join(appDir.path, uniqueFileName);
    await sourceFile.copy(profileImageU);

    // String hashPassword(String password) {
    //   final hashPassword = sha256.convert(utf8.encode(password)).toString();
    //   return hashPassword;
    // }
    // final hashedPassword = hashPassword(password);

    User user = User(
        name: nameController.text,
        username: nameController.text,
        password: password,
        profile_image: profileImagePath);

    insert('users', user);
    Get.snackbar('Completed', 'successfully registered',
        colorText: Colors.green);
    Get.offNamed(
      AppRoutes.loginScreen,
    );
  }

  updateUser(String table, User user, int id) async {
    Map<String, dynamic> userMap = user.toMap();
    int res = await DatabaseHelper.update(table, userMap, "id=$id");
    if (res > 0) {
      Get.offNamed(
        AppRoutes.homeScreen,
      );
    }
  }

  getOne(int id) async {
    return await DatabaseHelper.getOne('users', "id=$id");
  }

  getUsers(String table) async {
    List<Map> response = await DatabaseHelper.read(table);
    users.addAll(response);
  }

  insert(String table, User user) async {
    Map<String, dynamic> userMap = user.toMap();
    int response = await DatabaseHelper.insert(table, userMap);
    if (response > 0) {
      List<Map> lastInserted = await getLast();
      Map lastUser = lastInserted[0];
      users.add(lastUser);
    }
    return response;
  }

  getLast() async {
    return await DatabaseHelper.getLast(
        '''SELECT * FROM users ORDER BY id DESC LIMIT 1''');
  }

  @override
  void onInit() {
    super.onInit();
    getUsers('users');
  }
}
