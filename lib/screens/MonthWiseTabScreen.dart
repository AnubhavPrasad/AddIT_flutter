import 'package:add_it/controller/DayController.dart';
import 'package:add_it/controller/LimitController.dart';
import 'package:add_it/controller/MonthController.dart';
import 'package:add_it/database/DataBaseHelper.dart';
import 'package:add_it/utilities/SlidableTileMonth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'BarChartScreen.dart';

class MonthWiseTabScreen extends StatelessWidget {
  final MonthController monthController = Get.find();
  final DayController dayController = Get.find();
  final LimitController limitController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.bar_chart),
        onPressed: () {
          monthController.setInterval();
          Get.to(BarChartScreen());
        },
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: monthController.list.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async {
                List dayList = await dayController.query(
                    monthController.list[index][DataBaseHelper.monthCol]);
                if (dayList.length > 0) daysInMonthDialog(context, dayList);
              },
              child: Obx(
                () => SlidableTileMonth(
                  listData: monthController.list[index],
                  color: ((int.parse(limitController.monthLimit.value) <
                              monthController.list[index]
                                  [DataBaseHelper.monthValueCol] &&
                          int.parse(limitController.monthLimit.value) != -1))
                      ? Color(0xffD3423D)
                      : Color(0xff7ea2f8),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  //display days list when month item is pressed
  daysInMonthDialog(context, dayList) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: dayList.length,
          itemBuilder: (_, i) => Column(
            children: [
              ListTile(
                title: Text(dayList[i][DataBaseHelper.dayFullDateCol]),
                subtitle: Text('\u20B9 ' +
                    dayList[i][DataBaseHelper.dayValueCol].toString()),
              ),
              Container(
                height: 1,
                color: Colors.grey,
              )
            ],
          ),
        ),
      ),
    );
  }
}
