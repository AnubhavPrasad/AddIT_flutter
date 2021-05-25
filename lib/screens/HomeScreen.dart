import 'package:add_it/controller/DayController.dart';
import 'package:add_it/controller/ItemController.dart';
import 'package:add_it/controller/ItemEditController.dart';
import 'package:add_it/controller/LimitController.dart';
import 'package:add_it/controller/MenuController.dart';
import 'package:add_it/controller/MonthController.dart';
import 'package:add_it/database/DataBaseHelper.dart';
import 'package:add_it/models/MenuConstants.dart';
import 'package:add_it/screens/AboutScreen.dart';
import 'package:add_it/screens/MonthWiseTabScreen.dart';
import 'package:add_it/utilities/AddBottomSheet.dart';
import 'package:add_it/utilities/ItemListTile.dart';
import 'package:add_it/utilities/SlidableTileDay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:multi_select_item/multi_select_item.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MenuController menuController = Get.put(MenuController());
  final LimitController limitController = Get.put(LimitController());
  final ItemEditController itemEditController = Get.put(ItemEditController());
  final DayController dayController = Get.put(DayController());
  final ItemController itemController = Get.put(ItemController());
  final MonthController monthController = Get.put(MonthController());
  final MultiSelectController controller = MultiSelectController();
  var dayLimitController = TextEditingController();
  var monthLimitController = TextEditingController();

  @override
  void initState() {
    controller.set(dayController.list.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.dark,
            actions: [
              Visibility(
                visible: controller.isSelecting,
                child: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    dialogDisplay(
                      'Delete Selected',
                      () {
                        deleteSelected();
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              PopupMenuButton(
                onSelected: (choice) {
                  choiceAction(choice, context);
                },
                itemBuilder: (_) => Constants.choices
                    .map(
                      (choice) => PopupMenuItem(
                        child: Text(choice),
                        value: choice,
                      ),
                    )
                    .toList(),
              ),
            ],
            title: Text('AddIT'),
            bottom: TabBar(
              tabs: [
                Tab(
                  text: 'DAY-WISE',
                ),
                Tab(
                  text: 'MONTH-WISE',
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              dayWiseScreen(),
              MonthWiseTabScreen(),
            ],
          )),
    );
  }

  WillPopScope dayWiseScreen() {
    return WillPopScope(
      //to deselect all days when back is pressed
      onWillPop: () async {
        var before = !controller.isSelecting;
        setState(() {
          controller.deselectAll();
        });
        return before;
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            openAddBottomSheet();
          },
          child: Icon(Icons.add),
        ),
        body: Obx(
          () => dayController.list.length > 0
              ? ListView.builder(
                  itemCount: dayController.list.length,
                  itemBuilder: (context, index) {
                    return MultiSelectItem(
                      onSelected: () {
                        setState(
                          () {
                            controller.toggle(index);
                          },
                        );
                      },
                      isSelecting: controller.isSelecting,
                      child: AbsorbPointer(
                        //absorbing when selecting is true
                        absorbing: controller.isSelecting,
                        child: InkWell(
                          onTap: () {
                            showItems(index);
                          },
                          child: Obx(
                            () => SlidableTile(
                              listData: dayController.list[index],
                              icon: controller.isSelected(index)
                                  ? Icons.check
                                  : null,
                              isSelected: controller.isSelected(index),
                              color: ((int.parse(
                                              limitController.dayLimit.value) <
                                          dayController.list[index]
                                              [DataBaseHelper.dayValueCol] &&
                                      int.parse(
                                              limitController.dayLimit.value) !=
                                          -1))
                                  ? Color(0xffD3423D)
                                  : Color(0xff7ea2f8),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: GestureDetector(
                    onTap: () {
                      openAddBottomSheet();
                    },
                    child: Text(
                      '+ ADD IT',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  //Menu choice actions
  void choiceAction(String selected, context) async {
    if (selected == Constants.about) {
      Get.to(AboutScreen());
    } else if (selected == Constants.pickDate) {
      final picked = await showDatePicker(
        context: context,
        initialDate: menuController.selectedDate.value,
        firstDate: DateTime(2000),
        lastDate: DateTime(2111),
      );
      if (picked != null) {
        menuController.setDate(picked);
        Get.bottomSheet(
          FractionallySizedBox(
            heightFactor: 0.8,
            child: AddBottomSheet(),
          ),
        );
      }
    } else if (selected == Constants.deleteAll) {
      dialogDisplay(
        'Delete All',
        () {
          dayController.deleteAll();
          monthController.deleteAll();
          itemController.deleteAll();
          Navigator.pop(context);
        },
      );
    } else {
      if (int.parse(limitController.dayLimit.value) != -1) {
        dayLimitController.text = limitController.dayLimit.value;
        monthLimitController.text = limitController.monthLimit.value;
      }
      //Displaying Set limit dialog
      showDialog(
        context: context,
        builder: (context) {
          return setDialog();
        },
      );
    }
  }

  SimpleDialog setDialog() {
    return SimpleDialog(
      title: Center(
        child: Text(
          'Set Limit',
          style: TextStyle(letterSpacing: 2),
        ),
      ),
      children: [
        Container(
          padding: EdgeInsets.only(left: 40, right: 40, bottom: 20, top: 0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter Day Limit',
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                controller: dayLimitController,
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter Month Limit',
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                controller: monthLimitController,
              ),
            ],
          ),
        ),
        FractionallySizedBox(
          widthFactor: 0.5,
          child: TextButton(
            onPressed: () {
              addLimit();
            },
            child: Text('Set'),
          ),
        ),
      ],
    );
  }

  //open the add bottom sheet
  openAddBottomSheet() {
    menuController.setDate(DateTime.now());
    //displaying add bottomSheet
    Get.bottomSheet(
      FractionallySizedBox(
        heightFactor: 0.8,
        child: AddBottomSheet(),
      ),
    );
  }

// set limit for day and month by using limit controller
  addLimit() {
    var dayLimit = int.tryParse(dayLimitController.text);
    var monthLimit = int.tryParse(monthLimitController.text);
    if (dayLimitController.text == '' ||
        monthLimitController.text == '' ||
        dayLimit == null ||
        monthLimit == null) {
      return;
    }
    var row = {
      DataBaseHelper.limitIdCol: 1,
      DataBaseHelper.limitDayCol: dayLimit,
      DataBaseHelper.limitMonthCol: monthLimit,
    };

    if (int.parse(limitController.monthLimit.value) == -1) {
      limitController.insertLimit(row);
    } else {
      limitController.updateLimit(row);
    }
    Navigator.pop(context);
  }

  //Displaying items in a day in from of dialog
  showItems(index) async {
    await itemController
        .query(dayController.list[index][DataBaseHelper.dayFullDateCol]);
    itemsInDayDialog(context);
  }

  itemsInDayDialog(context) {
    showDialog(
      context: context,
      builder: (_) => Obx(
        () => Dialog(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: itemController.list.length,
            itemBuilder: (_, i) => ItemListTile(
              item: itemController.list[i],
            ),
          ),
        ),
      ),
    );
  }

  //Function to delete selected days from DayTab
  deleteSelected() {
    var dayList = dayController.list;
    var list = controller.selectedIndexes;
    Map m = {};
    list.sort((b, a) => a.compareTo(b));
    list.forEach((element) async {
      if (m.containsKey(dayList[element][DataBaseHelper.dayMonthCol])) {
        m[dayList[element][DataBaseHelper.dayMonthCol]] +=
            dayList[element][DataBaseHelper.dayValueCol];
      } else {
        m[dayList[element][DataBaseHelper.dayMonthCol]] =
            dayList[element][DataBaseHelper.dayValueCol];
      }
    });
    deductMonth(m);
    list.forEach((element) async {
      await itemController.deleteWithDate(dayList[element]);
      await dayController
          .delete(dayList[element][DataBaseHelper.dayFullDateCol]);
    });
    setState(() {
      controller.deselectAll();
      controller.set(dayController.list.length);
    });
  }

  //Deduct dayValues from MonthTab
  deductMonth(Map m) async {
    var monthList = monthController.list;
    print(m);
    for (var i in monthList) {
      if (m.containsKey(i[DataBaseHelper.monthCol])) {
        var row = {
          DataBaseHelper.monthCol: i[DataBaseHelper.monthCol],
          DataBaseHelper.monthValueCol:
              i[DataBaseHelper.monthValueCol] - m[i[DataBaseHelper.monthCol]],
          DataBaseHelper.monthDateCol: i[DataBaseHelper.monthDateCol],
        };
        await monthController.edit(row);
      }
    }
  }

  //Generic dialog for deletion purpose
  dialogDisplay(text, onPressed) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(text),
        content: Text('Are you Sure ?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: onPressed,
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }
}
