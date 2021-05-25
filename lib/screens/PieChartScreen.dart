import 'package:add_it/constants.dart';
import 'package:add_it/controller/ItemController.dart';
import 'package:add_it/database/DataBaseHelper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PieChartScreen extends StatefulWidget {
  final itemList;

  PieChartScreen({this.itemList});

  @override
  _PieChartScreenState createState() => _PieChartScreenState();
}

class _PieChartScreenState extends State<PieChartScreen> {
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
        child: PieChart(
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
            sections: showSections(widget.itemList),
          ),
        ),
      ),
    );
  }

  List showSections(List itemList) {
    return itemList
        .asMap()
        .map(
          (index, data) {
            final bool isTouched = touchedIndex == index;
            final radius = isTouched ? 120 : 110;
            final size = isTouched ? 15 : 13;
            final value = PieChartSectionData(
                color: colors[index % 8],
                radius: radius.toDouble(),
                titleStyle: TextStyle(fontSize: size.toDouble()),
                title: data[DataBaseHelper.itemCol] +
                    '\n' +
                    data[DataBaseHelper.itemPriceCol].toString(),
                value: data[DataBaseHelper.itemPriceCol].toDouble());
            return MapEntry(index, value);
          },
        )
        .values
        .toList();
  }
}
