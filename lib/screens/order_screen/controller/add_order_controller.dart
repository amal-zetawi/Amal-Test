import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Talabat/sql/db_helper.dart';

class AddOrderController extends GetxController {
  TextEditingController dateController = TextEditingController();
  TextEditingController currencyController = TextEditingController();
  TextEditingController currencyNameController = TextEditingController();
  TextEditingController currencySymbolController = TextEditingController();
  TextEditingController currencyRateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController equalAmmountController = TextEditingController();


  var selectedCurrency = ''.obs;
  RxDouble rate = 0.0.obs;
  RxInt currencyId = 0.obs;
  String currencyName ='';
  String userName='';
  RxInt userId=0.obs;
  RxString stateKeyword = "".obs;
  RxBool isChecked = false.obs;
  RxInt userItem=0.obs;
  RxInt selectType =0.obs;
  String type='';
   String status ='';
   int idCurrency=0;
  RxInt selectStates=0.obs;
  RxList orders = [].obs;
  RxDouble eAmount=0.0.obs;
  int idUser =0;

  updateEAmount(double value) {
    eAmount.value = value;
  }

  updateRate(double value) {
    rate.value = value;
  }
  // Method to update the selected currency
  void updateSelectedCurrency(String currency) {
    selectedCurrency.value = currency;
  }

  RxList<String> selectedItems = <String>[].obs;
  RxList<String> selectedItemsPrice = <String>[].obs;


  @override
  void onInit() {
    super.onInit();
    dateController = TextEditingController();
    currencyController = TextEditingController();
    selectedCurrency.value = 'defaultCurrencyId';
    ever(eAmount, (double value) {
      double equalAmount = equalAmmount(double.parse(amountController.text), value);
      equalAmmountController.text = equalAmount.toString();
    });
    super.onInit();
  }


  Future<void> saveCurrency() async {
    if (currencyNameController.text.isEmpty ||
        currencySymbolController.text.isEmpty ||
        currencyRateController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields.',
          colorText: Colors.red);
      return;
    }
    await DatabaseHelper.saveCurrency(
      currencyNameController.text,
      currencySymbolController.text,
      double.parse(currencyRateController.text),
    );
    DatabaseHelper.getAllCurrency();
  }

  double equalAmmount(double amount, double value) {
    return amount / value;
  }

  upadateCurrencyId(int value) {
    currencyId.value = value;
    idCurrency=value;
  }

  upadateCurrencyName(int value) {
    currencyId.value = value;
  }

  upadateUserId(int value) {
    userId.value = value;
    idUser=value;
  }

  upadateUserName(String value) {
    userName= value;
  }

  upadateItemsId(int value) {
    userItem.value = value;
  }

  void updateType(value) {
    selectType.value= value;
    if(selectType.value==0){
      type='Sell Order';
    }
    else if(selectType.value==1){
      type='Purchased Order';
    }
    else if(selectType.value==2){
     type='Return Sell Order';
    }
    else if(selectType.value==3){
      type='Return Purchased Order';
    }


  }

  updateStateKeyWord(value) {
    if (value == 1) {
      stateKeyword.value = "Paid";
    }
    return stateKeyword.value;
  }

  toggleCheck(value) {
    isChecked.value = value!;
  }

  void updateStates(value) {
    selectStates.value = value;
    if(value==0){
      status='paid';
    }
    else if(value==1){
      status='not';

    }
  }

  Future<void> saveOrder() async {
    // if (itemNameController.text.isEmpty ||
    //     itemPriceController.text.isEmpty) {
    //   Get.snackbar('Error', 'Please fill in all fields.',
    //       colorText: Colors.red);
    //   return;
    // }
    double doubleRate = rate.value;
    updateEAmount(doubleRate);
   double equalA= equalAmmount(double.parse(amountController.text),doubleRate);
    await DatabaseHelper.saveOrder(
        dateController.text,
        idCurrency,
        idUser,
        status,
        type,
       double.parse(amountController.text) ,
        equalA
    );

   // DatabaseHelper.getAllItems();
  }

  void addItem(String item) {
    selectedItems.add(item);
  }

  void removeItem(String item) {
    selectedItems.remove(item);
  }

  updateOrderState(int state, int id) async {
    int response = await DatabaseHelper.updateOrderState('''
    UPDATE 'orders' SET status=$state WHERE order_Id=$id
''');
    if (response > 0) {
      //await updateLocalSolution(id);
    }
  }

}

