import 'package:add_it/database/DataBaseHelper.dart';
import 'package:get/get.dart';

class DayController extends GetxController {
  var list = [].obs;

  DayController() {
    queryAll();
  }

  insert(Map<String, dynamic> row) async {
    int id = await DataBaseHelper.instance.dayInsert(row);
    queryAll();
    return id;
  }

  edit(Map<String, dynamic> row) async {
    await DataBaseHelper.instance.dayUpdate(row);
    queryAll();
  }

  deleteAll() async {
    await DataBaseHelper.instance.dayDeleteAll();
    queryAll();
  }

  delete(String date) async {
    await DataBaseHelper.instance.dayDelete(date);
    queryAll();
  }

  deleteWithMonth(Map<String, dynamic> row) async {
    await DataBaseHelper.instance.dayDeleteWithMonth(row);
    queryAll();
  }

  queryAll() async {
    List tempList = await DataBaseHelper.instance.dayQueryAll();
    list.value = tempList.reversed.toList();
  }

  query(String month) async {
    var list = DataBaseHelper.instance.dayQueryForMonth(month);
    return list;
  }
}
