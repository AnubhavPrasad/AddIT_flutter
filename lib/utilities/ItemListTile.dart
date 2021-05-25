import 'package:add_it/controller/DayController.dart';
import 'package:add_it/controller/ItemController.dart';
import 'package:add_it/controller/MenuController.dart';
import 'package:add_it/controller/MonthController.dart';
import 'package:add_it/database/DataBaseHelper.dart';
import 'package:add_it/utilities/EditBottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemListTile extends StatelessWidget {
  final item;
  final MenuController menuController = Get.find();
  final ItemController itemController = Get.find();
  final MonthController monthController = Get.find();
  final DayController dayController = Get.find();

  ItemListTile({this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        //Display edit bottomSheet when clicked on a item in dialog
        Get.bottomSheet(
          FractionallySizedBox(
            heightFactor: 0.8,
            child: EditBottomSheet(
              itemDetail: item,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item[DataBaseHelper.itemCol]),
                Row(
                  children: [
                    Text('\u20B9 ' +
                        item[DataBaseHelper.itemPriceCol].toString()),
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      child: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Delete Item'),
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
                                  itemDelete();
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
                )
              ],
            ),
          ),
          Divider(
            height: 1,
          ),
        ],
      ),
    );
  }

// Delete Item from Dialog after clicking a ListTile in days

  itemDelete() {
    itemController.delete(item);
    deductItemFromMonth();
    deductItemFromDay();
  }

  deductItemFromMonth() async {
    var monthList = monthController.list;
    for (var i in monthList) {
      if (i[DataBaseHelper.monthCol] == item[DataBaseHelper.itemMonthCol]) {
        var row = {
          DataBaseHelper.monthDateCol: i[DataBaseHelper.monthDateCol],
          DataBaseHelper.monthCol: i[DataBaseHelper.monthCol],
          DataBaseHelper.monthValueCol: i[DataBaseHelper.monthValueCol] -
              item[DataBaseHelper.itemPriceCol],
        };
        await monthController.edit(row);
        return;
      }
    }
  }

  deductItemFromDay() async {
    var dayList = dayController.list;
    for (var i in dayList) {
      if (i[DataBaseHelper.dayFullDateCol] ==
          item[DataBaseHelper.itemDateCol]) {
        var row = {
          DataBaseHelper.dayMonthCol: i[DataBaseHelper.dayMonthCol],
          DataBaseHelper.dayFullDateCol: i[DataBaseHelper.dayFullDateCol],
          DataBaseHelper.dayValueCol:
              i[DataBaseHelper.dayValueCol] - item[DataBaseHelper.itemPriceCol],
        };
        await dayController.edit(row);
        return;
      }
    }
  }
}
