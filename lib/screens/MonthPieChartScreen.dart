import 'package:add_it/controller/ItemController.dart';
import 'package:add_it/database/DataBaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

import '../constants.dart';

class MonthPieChartScreen extends StatefulWidget {
  final dayList;
  MonthPieChartScreen({this.dayList});

  @override
  _MonthPieChartScreenState createState() => _MonthPieChartScreenState();
}

class _MonthPieChartScreenState extends State<MonthPieChartScreen> {
  final ItemController itemController = Get.find();
  var touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text('Pie Chart'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Stack(
          children: [
            PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  enabled: true,
                  touchCallback: (pieTouchResponse) {
                    setState(
                      () {
                        touchedIndex =
                            pieTouchResponse.touchedSection.touchedSectionIndex;
                      },
                    );
                  },
                ),
                sections: showSections(widget.dayList),
              ),
            ),
            Align(
              child: Text(widget.dayList[0][DataBaseHelper.dayMonthCol]),
              alignment: Alignment.center,
            )
          ],
        ),
      ),
    );
  }

  List showSections(List dayList) {
    return dayList
        .asMap()
        .map(
          (index, data) {
            final bool isTouched = touchedIndex == index;
            final radius = isTouched ? 110 : 100;
            final size = isTouched ? 15 : 13;
            final value = PieChartSectionData(
                color: colors[index % 8],
                radius: radius.toDouble(),
                titleStyle: TextStyle(fontSize: size.toDouble()),
                title: data[DataBaseHelper.dayFullDateCol] +
                    '\n' +
                    data[DataBaseHelper.dayValueCol].toString(),
                value: data[DataBaseHelper.dayValueCol].toDouble());
            return MapEntry(index, value);
          },
        )
        .values
        .toList();
  }
}
