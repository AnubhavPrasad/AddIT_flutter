import 'package:add_it/database/DataBaseHelper.dart';
import 'package:get/get.dart';

class ItemController extends GetxController {
  var list = [].obs;

  insert(Map<String, dynamic> row) async {
    int id = await DataBaseHelper.instance.itemInsert(row);
    query(row[DataBaseHelper.itemDateCol]);
    return id;
  }

  edit(Map<String, dynamic> row) async {
    await DataBaseHelper.instance.itemUpdate(row);
    query(row[DataBaseHelper.itemDateCol]);
  }

  delete(Map<String, dynamic> row) async {
    await DataBaseHelper.instance.itemDelete(row);
    query(row[DataBaseHelper.itemDateCol]);
  }

  deleteWithDate(Map<String, dynamic> row) async {
    await DataBaseHelper.instance.itemDeleteWithDate(row);
  }

  deleteWithMonth(Map<String, dynamic> row) async {
    await DataBaseHelper.instance.itemDeleteWithMonth(row);
  }

  deleteAll() async {
    await DataBaseHelper.instance.itemDeleteAll();
  }

  query(String date) async {
    List tempList = await DataBaseHelper.instance.itemQuery(date);
    list.value = tempList.reversed.toList();
  }
}
