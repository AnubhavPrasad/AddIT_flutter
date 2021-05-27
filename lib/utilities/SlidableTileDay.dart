import 'package:add_it/controller/DayController.dart';
import 'package:add_it/controller/ItemController.dart';
import 'package:add_it/controller/LimitController.dart';
import 'package:add_it/controller/MonthController.dart';
import 'package:add_it/database/DataBaseHelper.dart';
import 'package:add_it/screens/PieChartScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class SlidableTile extends StatelessWidget {
  final listData;
  final DayController dayController = Get.find();
  final MonthController monthController = Get.find();
  final ItemController itemController = Get.find();
  final LimitController limitController = Get.find();
  final icon;
  final isSelected;
  final color;

  SlidableTile({this.listData, this.icon, this.isSelected, this.color});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableStrechActionPane(),
      actionExtentRatio: 0.20,
      child: Container(
        padding: EdgeInsets.only(right: 8.0),
        color: Colors.transparent,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: isSelected ? Colors.green[400] : color,
            child: icon == null
                ? Text(listData[DataBaseHelper.dayMonthCol])
                : Icon(icon),
            foregroundColor: Colors.white,
          ),
          title: Text(
            listData[DataBaseHelper.dayFullDateCol],
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          subtitle: Text(
            '\u20B9 ' + listData[DataBaseHelper.dayValueCol].toString(),
            style: TextStyle(
                fontSize: 18,
                color: Get.isDarkMode ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold),
          ),
          trailing: GestureDetector(
            onTap: () async {
              await itemController
                  .query(listData[DataBaseHelper.dayFullDateCol]);
              Get.to(PieChartScreen(itemList: itemController.list));
            },
            child: Icon(FontAwesomeIcons.chartPie),
          ),
        ),
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            displayDayDeleteDialog(context);
          },
        ),
        IconSlideAction(
          caption: 'Pie',
          color: Colors.grey,
          foregroundColor: Colors.white,
          icon: Icons.pie_chart_sharp,
          onTap: () async {
            await itemController.query(listData[DataBaseHelper.dayFullDateCol]);
            Get.to(PieChartScreen(itemList: itemController.list));
          },
        )
      ],
    );
  }

  //Delete day from DatTab through slidable delete button
  displayDayDeleteDialog(context) {
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
              deleteDay();
              Navigator.pop(context);
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  deleteDay() async {
    await dayController.delete(listData[DataBaseHelper.dayFullDateCol]);
    deductFromMonth();
    removeItems();
  }

  deductFromMonth() async {
    var monthList = monthController.list;
    for (var i in monthList) {
      if (i[DataBaseHelper.monthCol] == listData[DataBaseHelper.dayMonthCol]) {
        var row = {
          DataBaseHelper.monthDateCol: i[DataBaseHelper.monthDateCol],
          DataBaseHelper.monthCol: i[DataBaseHelper.monthCol],
          DataBaseHelper.monthValueCol: i[DataBaseHelper.monthValueCol] -
              listData[DataBaseHelper.dayValueCol],
        };
        await monthController.edit(row);
        return;
      }
    }
  }

  removeItems() async {
    await itemController.deleteWithDate(listData);
    return;
  }
}
