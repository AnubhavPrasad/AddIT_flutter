import 'dart:math';

import 'package:add_it/database/DataBaseHelper.dart';
import 'package:get/get.dart';

class MonthController extends GetxController {
  var list = [].obs;
  var interval = 0.toDouble().obs;
  MonthController() {
    queryAll();
  }

  insert(Map<String, dynamic> row) async {
    int id = await DataBaseHelper.instance.monthInsert(row);
    queryAll();
    return id;
  }

  edit(Map<String, dynamic> row) async {
    await DataBaseHelper.instance.monthUpdate(row);
    queryAll();
  }

  delete(String month) async {
    await DataBaseHelper.instance.monthDelete(month);
    queryAll();
  }

  deleteAll() async {
    await DataBaseHelper.instance.monthDeleteAll();
    queryAll();
  }

  queryAll() async {
    list.value = await DataBaseHelper.instance.monthQueryAll();
    return list;
  }

  setInterval() {
    var value = 0;
    for (var i in list) {
      value = max(value, i[DataBaseHelper.monthValueCol]);
    }
    interval.value = value.toDouble();
  }
}
