import 'package:get/get.dart';

class ItemEditController extends GetxController {
  var item = ''.obs;
  var price = ''.obs;

  setItem(String item) {
    this.item.value = item;
  }

  setPrice(String price) {
    this.price.value = price;
  }
}
