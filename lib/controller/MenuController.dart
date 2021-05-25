import 'package:add_it/database/DataBaseHelper.dart';
import 'package:get/get.dart';

class MenuController extends GetxController {
  var selectedDate = DateTime.now().obs;

  setDate(date) {
    selectedDate.value = date;
  }
}
