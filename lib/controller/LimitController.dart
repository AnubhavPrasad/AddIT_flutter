import 'package:add_it/database/DataBaseHelper.dart';
import 'package:get/get.dart';

class LimitController extends GetxController {
  var monthLimit = '-1'.obs;
  var dayLimit = '-1'.obs;
  LimitController() {
    query();
  }
  insertLimit(Map<String, dynamic> row) async {
    await DataBaseHelper.instance.limitInsert(row);
    query();
  }

  updateLimit(Map<String, dynamic> row) async {
    await DataBaseHelper.instance.limitUpdate(row);
    query();
  }

  query() async {
    List list = await DataBaseHelper.instance.limitRead();
    if (list.length > 0) {
      monthLimit.value = list[0][DataBaseHelper.limitMonthCol].toString();
      dayLimit.value = list[0][DataBaseHelper.limitDayCol].toString();
      print(dayLimit);
      print(monthLimit);
    }
  }
}
