import 'package:add_it/controller/MonthController.dart';
import 'package:add_it/database/DataBaseHelper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BarChartScreen extends StatelessWidget {
  final MonthController monthController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text('Bar Chart'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: AspectRatio(
            aspectRatio: 0.7,
            child: BarChart(BarChartData(
              borderData: FlBorderData(
                border: Border(
                  top: BorderSide.none,
                  right: BorderSide.none,
                  left: BorderSide(width: 1, color: Colors.grey[300]),
                  bottom: BorderSide(width: 1, color: Colors.grey[300]),
                ),
              ),
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Colors.transparent,
                  tooltipPadding: const EdgeInsets.all(0),
                  tooltipMargin: 8,
                  getTooltipItem: (
                    BarChartGroupData group,
                    int groupIndex,
                    BarChartRodData rod,
                    int rodIndex,
                  ) {
                    return BarTooltipItem(
                      rod.y.toInt().toString(),
                      TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
              alignment: BarChartAlignment.spaceEvenly,
              titlesData: FlTitlesData(
                show: true,
                leftTitles: SideTitles(
                  getTextStyles: (value) {
                    return TextStyle(color: Colors.white, fontSize: 11);
                  },
                  showTitles: monthController.interval.value > 0 ? true : false,
                  interval: monthController.interval.value > 0
                      ? monthController.interval.value / 10
                      : null,
                  getTitles: (double value) {
                    return value.toInt().toString();
                  },
                ),
                bottomTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (value) {
                    return TextStyle(color: Colors.white, fontSize: 11);
                  },
                  getTitles: (double value) {
                    switch (value.toInt()) {
                      case 0:
                        return 'Jan';
                      case 2:
                        return 'Mar';
                      case 4:
                        return 'May';
                      case 6:
                        return 'Jul';
                      case 8:
                        return 'Sep';
                      case 10:
                        return 'Nov';
                      default:
                        return '';
                    }
                  },
                ),
              ),
              barGroups: barGroupList(),
            )),
          ),
        ),
      ),
    );
  }

  barGroupList() {
    var width = 20.toDouble();
    var radius = BorderRadius.only(
        topLeft: Radius.circular(5), topRight: Radius.circular(5));
    List<BarChartGroupData> list = [];
    int i = 0;
    while (i < 12) {
      list.add(BarChartGroupData(x: i, barRods: [BarChartRodData(y: 0)]));
      i++;
    }
    for (var i in monthController.list) {
      if (i[DataBaseHelper.monthCol] == 'Jan') {
        list[0] = BarChartGroupData(x: 0, barRods: [
          BarChartRodData(
              colors: [Color(0xff33CD74)],
              borderRadius: radius,
              y: i[DataBaseHelper.monthValueCol].toDouble(),
              width: width)
        ]);
      } else if (i[DataBaseHelper.monthCol] == 'Feb') {
        list[1] = BarChartGroupData(x: 1, barRods: [
          BarChartRodData(
              colors: [Color(0xff33CD74)],
              borderRadius: radius,
              y: i[DataBaseHelper.monthValueCol].toDouble(),
              width: width)
        ]);
      } else if (i[DataBaseHelper.monthCol] == 'Mar') {
        list[2] = BarChartGroupData(x: 2, barRods: [
          BarChartRodData(
              colors: [Color(0xff3598DB)],
              borderRadius: radius,
              y: i[DataBaseHelper.monthValueCol].toDouble(),
              width: width)
        ]);
      } else if (i[DataBaseHelper.monthCol] == 'Apr') {
        list[3] = BarChartGroupData(x: 3, barRods: [
          BarChartRodData(
              colors: [Color(0xfff6b5f6)],
              y: i[DataBaseHelper.monthValueCol].toDouble(),
              borderRadius: radius,
              width: width)
        ]);
      } else if (i[DataBaseHelper.monthCol] == 'May') {
        list[4] = BarChartGroupData(
          x: 4,
          barRods: [
            BarChartRodData(
                colors: [Color(0xff3C4E61)],
                borderRadius: radius,
                y: i[DataBaseHelper.monthValueCol].toDouble(),
                width: width)
          ],
        );
      } else if (i[DataBaseHelper.monthCol] == 'Jun') {
        list[5] = BarChartGroupData(x: 5, barRods: [
          BarChartRodData(
              colors: [Color(0xff6AA392)],
              borderRadius: radius,
              y: i[DataBaseHelper.monthValueCol].toDouble(),
              width: width)
        ]);
      } else if (i[DataBaseHelper.monthCol] == 'Jul') {
        list[6] = BarChartGroupData(x: 6, barRods: [
          BarChartRodData(
              colors: [Color(0xffFEDC7B)],
              borderRadius: radius,
              y: i[DataBaseHelper.monthValueCol].toDouble(),
              width: width)
        ]);
      } else if (i[DataBaseHelper.monthCol] == 'Aug') {
        list[7] = BarChartGroupData(x: 7, barRods: [
          BarChartRodData(
              colors: [Color(0xffF79A71)],
              borderRadius: radius,
              y: i[DataBaseHelper.monthValueCol].toDouble(),
              width: width)
        ]);
      } else if (i[DataBaseHelper.monthCol] == 'Sep') {
        list[8] = BarChartGroupData(x: 8, barRods: [
          BarChartRodData(
              colors: [Color(0xffDF614A)],
              borderRadius: radius,
              y: i[DataBaseHelper.monthValueCol].toDouble(),
              width: width)
        ]);
      } else if (i[DataBaseHelper.monthCol] == 'Oct') {
        list[9] = BarChartGroupData(x: 9, barRods: [
          BarChartRodData(
              colors: [Color(0xff981F62)],
              borderRadius: radius,
              y: i[DataBaseHelper.monthValueCol].toDouble(),
              width: width)
        ]);
      } else if (i[DataBaseHelper.monthCol] == 'Nov') {
        list[10] = BarChartGroupData(x: 10, barRods: [
          BarChartRodData(
              colors: [Color(0xff34377A)],
              borderRadius: radius,
              y: i[DataBaseHelper.monthValueCol].toDouble(),
              width: width)
        ]);
      } else if (i[DataBaseHelper.monthCol] == 'Dec') {
        list[11] = BarChartGroupData(x: 11, barRods: [
          BarChartRodData(
              colors: [Color(0xff7E3B4D)],
              borderRadius: radius,
              y: i[DataBaseHelper.monthValueCol].toDouble(),
              width: width)
        ]);
      }
    }
    return list;
  }
}
