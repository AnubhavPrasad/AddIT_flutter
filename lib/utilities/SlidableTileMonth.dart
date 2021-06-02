import 'package:add_it/controller/DayController.dart';
import 'package:add_it/controller/ItemController.dart';
import 'package:add_it/controller/MonthController.dart';
import 'package:add_it/database/DataBaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class SlidableTileMonth extends StatelessWidget {
  final listData;
  final MonthController monthController = Get.find();
  final DayController dayController = Get.find();
  final ItemController itemController = Get.find();
  final color;
  SlidableTileMonth({this.listData, this.color});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableStrechActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color,
            child: Text(listData[DataBaseHelper.monthCol]),
            foregroundColor: Colors.white,
          ),
          title: Text(listData[DataBaseHelper.monthDateCol],
              style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          subtitle: Text(
              '\u20B9 ' + listData[DataBaseHelper.monthValueCol].toString(),
              style: TextStyle(
                  fontSize: 18,
                  color: Get.isDarkMode ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold)),
        ),
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () async {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Delete'),
                content: Text('Are you Sure ?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      deleteMonth();
                      Navigator.pop(context);
                    },
                    child: Text('Yes'),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  //Delete month from monthTab through slidable delete button
  deleteMonth() async {
    monthController.delete(listData[DataBaseHelper.monthCol]);
    removeDays();
    removeItems();
  }

  removeDays() async {
    for (var i in dayController.list) {
      if (i[DataBaseHelper.dayMonthCol] == listData[DataBaseHelper.monthCol]) {
        await dayController.deleteWithMonth(i);
        return;
      }
    }
  }

  removeItems() async {
    for (var i in itemController.list) {
      if (i[DataBaseHelper.itemMonthCol] == listData[DataBaseHelper.monthCol]) {
        await itemController.deleteWithMonth(i);
        return;
      }
    }
  }
}
