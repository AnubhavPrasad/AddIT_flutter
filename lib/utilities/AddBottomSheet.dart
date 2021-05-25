import 'package:add_it/controller/DayController.dart';
import 'package:add_it/controller/ItemController.dart';
import 'package:add_it/controller/MenuController.dart';
import 'package:add_it/controller/MonthController.dart';
import 'package:add_it/database/DataBaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddBottomSheet extends StatefulWidget {
  @override
  _AddBottomSheetState createState() => _AddBottomSheetState();
}

class _AddBottomSheetState extends State<AddBottomSheet> {
  DayController dayController = Get.find();
  MonthController monthController = Get.find();
  ItemController itemController = Get.find();
  MenuController menuController = Get.find();
  TextEditingController itemEditController = TextEditingController();
  TextEditingController priceEditController = TextEditingController();
  bool validate = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                color: Theme.of(context).primaryColor,
                child: Row(
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Get.back();
                        }),
                    Text(
                      'ADD',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: -40,
                right: 20,
                top: 0,
                child: FloatingActionButton(
                  onPressed: () {
                    addData();
                  },
                  child: Icon(Icons.add),
                ),
              ),
            ],
          ),
          Flexible(
            child: SizedBox(
              height: 40,
            ),
          ),
          Flexible(
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    FocusScope.of(context).nextFocus();
                  },
                  controller: itemEditController,
                  decoration: InputDecoration(
                    hintText: 'Enter Item',
                  ),
                )),
          ),
          Flexible(
            child: SizedBox(
              height: 20,
            ),
          ),
          Flexible(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                textInputAction: TextInputAction.done,
                onSubmitted: (value) {
                  addData();
                  FocusScope.of(context).previousFocus();
                },
                onTap: () {
                  setState(() {
                    validate = false;
                  });
                },
                controller: priceEditController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    errorText: validate ? 'Price is required' : null,
                    hintText: 'Enter Price'),
              ),
            ),
          )
        ],
      ),
    );
  }

//Add in days ,month and items if not present otherwise update them accordingly
  void addData() async {
    DateTime dateTime = menuController.selectedDate.value;
    var month = DateFormat('MMM').format(dateTime);
    var monthDate = DateFormat('MMMM-yyyy').format(dateTime);
    var dayDate = DateFormat('dd-MM-yyyy').format(dateTime);
    if (priceEditController.text == '') {
      setState(() {
        validate = true;
      });
      return;
    }
    if (!dayPresent(dayDate, month)) {
      int id = await dayController.insert({
        DataBaseHelper.dayValueCol: priceEditController.text,
        DataBaseHelper.dayFullDateCol: dayDate,
        DataBaseHelper.dayMonthCol: month,
      });
    }
    if (!monthPresent(month, monthDate)) {
      var row = {
        DataBaseHelper.monthCol: month,
        DataBaseHelper.monthValueCol: priceEditController.text,
        DataBaseHelper.monthDateCol: monthDate,
      };
      int id = await monthController.insert(row);
      print(id);
    }
    addItem(month, dayDate);
    itemEditController.text = '';
    priceEditController.text = '';
    FocusScope.of(context).previousFocus();
  }

  //add items in database
  addItem(String month, String date) async {
    var row = {
      DataBaseHelper.itemMonthCol: month,
      DataBaseHelper.itemDateCol: date,
      DataBaseHelper.itemCol: itemEditController.text,
      DataBaseHelper.itemPriceCol: priceEditController.text,
    };
    int id = await itemController.insert(row);
  }

  //check if day is already present then update and return true
  bool dayPresent(String date, String month) {
    for (var i in dayController.list) {
      if (i[DataBaseHelper.dayFullDateCol] == date) {
        Map<String, dynamic> row = {
          DataBaseHelper.dayFullDateCol: date,
          DataBaseHelper.dayMonthCol: month,
          DataBaseHelper.dayValueCol: i[DataBaseHelper.dayValueCol] +
              int.parse(priceEditController.text),
        };
        dayController.edit(row);
        return true;
      }
    }
    return false;
  }

//check if month is already present then update and return true
  bool monthPresent(String month, String monthDate) {
    for (var i in monthController.list) {
      if (i[DataBaseHelper.monthCol] == month) {
        var row = {
          DataBaseHelper.monthCol: month,
          DataBaseHelper.monthValueCol: i[DataBaseHelper.monthValueCol] +
              int.parse(priceEditController.text),
          DataBaseHelper.monthDateCol: monthDate,
        };
        monthController.edit(row);
        return true;
      }
    }
    return false;
  }
}
