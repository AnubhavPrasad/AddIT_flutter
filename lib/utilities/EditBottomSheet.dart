import 'package:add_it/controller/DayController.dart';
import 'package:add_it/controller/ItemController.dart';
import 'package:add_it/controller/MenuController.dart';
import 'package:add_it/controller/MonthController.dart';
import 'package:add_it/database/DataBaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditBottomSheet extends StatefulWidget {
  final itemDetail;

  EditBottomSheet({this.itemDetail});

  @override
  _EditBottomSheetState createState() => _EditBottomSheetState();
}

class _EditBottomSheetState extends State<EditBottomSheet> {
  DayController dayController = Get.find();
  MonthController monthController = Get.find();
  ItemController itemController = Get.find();
  MenuController menuController = Get.find();
  bool validate = false;
  TextEditingController itemEditController = TextEditingController();
  TextEditingController priceEditController = TextEditingController();
  int id;

//putting values in text fields that need to be edited
  @override
  void initState() {
    id = widget.itemDetail[DataBaseHelper.itemIdCol];
    itemEditController.text = widget.itemDetail[DataBaseHelper.itemCol];
    priceEditController.text =
        widget.itemDetail[DataBaseHelper.itemPriceCol].toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Get.isDarkMode ? Color(0xFF2B2B2B) : Colors.grey[300],
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
                      'EDIT',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )
                  ],
                ),
              ),
              Positioned(
                  bottom: -30,
                  right: 10,
                  top: 10,
                  child: FloatingActionButton(
                    onPressed: () {
                      editData();
                    },
                    child: Icon(Icons.edit),
                  )),
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
                  controller: priceEditController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: 'Enter Price',
                      errorText: validate ? 'Price is required' : null),
                  onChanged: (value) {
                    setState(() {
                      validate = false;
                    });
                  },
                )),
          )
        ],
      ),
    );
  }

  //edit items, days and months when clicked on edit button on bottomsheet
  void editData() async {
    DateTime dateTime = DateFormat('dd-MM-yyyy')
        .parse(widget.itemDetail[DataBaseHelper.itemDateCol]);
    var month = DateFormat('MMM').format(dateTime);
    var monthDate = DateFormat('MMMM-yyyy').format(dateTime);
    var dayDate = DateFormat('dd-MM-yyyy').format(dateTime);
    if (priceEditController.text == '') {
      setState(() {
        validate = true;
      });
      return;
    }
    updateDay(dayDate, month);
    updateMonth(month, monthDate);
    updateItem(month, dayDate);
    Get.back();
  }

  //update the day data after editing
  updateDay(String date, String month) {
    for (var i in dayController.list) {
      if (i[DataBaseHelper.dayFullDateCol] == date) {
        Map<String, dynamic> row = {
          DataBaseHelper.dayFullDateCol: date,
          DataBaseHelper.dayMonthCol: month,
          DataBaseHelper.dayValueCol: i[DataBaseHelper.dayValueCol] +
              int.parse(priceEditController.text) -
              widget.itemDetail[DataBaseHelper.itemPriceCol],
        };
        dayController.edit(row);
        return;
      }
    }
  }

//update the month data after editing
  updateMonth(String month, String monthDate) {
    for (var i in monthController.list) {
      if (i[DataBaseHelper.monthCol] == month) {
        var row = {
          DataBaseHelper.monthCol: month,
          DataBaseHelper.monthValueCol: i[DataBaseHelper.monthValueCol] +
              int.parse(priceEditController.text) -
              widget.itemDetail[DataBaseHelper.itemPriceCol],
          DataBaseHelper.monthDateCol: monthDate,
        };
        monthController.edit(row);
        return;
      }
    }
  }

//update the item data after editing
  updateItem(String month, String date) async {
    var row = {
      DataBaseHelper.itemIdCol: widget.itemDetail[DataBaseHelper.itemIdCol],
      DataBaseHelper.itemMonthCol: month,
      DataBaseHelper.itemDateCol: date,
      DataBaseHelper.itemCol: itemEditController.text,
      DataBaseHelper.itemPriceCol: priceEditController.text,
    };
    await itemController.edit(row);
  }
}
