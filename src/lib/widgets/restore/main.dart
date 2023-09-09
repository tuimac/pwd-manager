import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:src/services/fileio.dart';
import 'package:src/utils/dateFormat.dart';
import 'package:src/utils/unitConvert.dart';
import 'package:src/widgets/restore/deleteDialog.dart';
import 'package:src/widgets/restore/restoreDialog.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:flutter/cupertino.dart';
import 'dart:developer';

class Restore extends StatefulWidget {
  const Restore({Key? key}) : super(key: key);

  @override
  State<Restore> createState() => _RestoreState();
}

class _RestoreState extends State<Restore> {
  final formKey = GlobalKey<FormState>();
  late List<Map<String, dynamic>> restoreDataList = [];
  ScrollController scrollContrl = ScrollController();
  String lastSortType = 'Date';
  Map<String, dynamic> sortTypes = {
    'Date': {'decend': false},
    'Size': {'decend': true}
  };
  bool sortDropDownMenu = false;

  @override
  void initState() {
    getRestoreDataList();
    super.initState();
  }

  void getRestoreDataList() async {
    await FileIO.getRestoreInfo().then((result) {
      setState(() {
        restoreDataList = result;
        sortData('Date');
      });
    });
  }

  void refreshState() {
    setState(() {});
  }

  void sortData(String sortType) {
    setState(() {
      switch (sortType) {
        case 'Date':
          if (sortTypes[sortType]['decend']) {
            restoreDataList.sort((a, b) => DateFormat('yyyy-MM-dd-HH-mm-ss')
                .parse(DateConverter.dateForFileName(a['name']))
                .compareTo(DateFormat('yyyy-MM-dd-HH-mm-ss')
                    .parse(DateConverter.dateForFileName(b['name']))));
            sortTypes[sortType]['decend'] = false;
          } else {
            restoreDataList.sort((a, b) => DateFormat('yyyy-MM-dd-HH-mm-ss')
                .parse(DateConverter.dateForFileName(b['name']))
                .compareTo(DateFormat('yyyy-MM-dd-HH-mm-ss')
                    .parse(DateConverter.dateForFileName(a['name']))));
            sortTypes[sortType]['decend'] = true;
          }
          lastSortType = sortType;
          break;
        case 'Size':
          if (sortTypes[sortType]['decend']) {
            restoreDataList.sort((a, b) => a['size'].compareTo(b['size']));
            sortTypes[sortType]['decend'] = false;
          } else {
            restoreDataList.sort((a, b) => b['size'].compareTo(a['size']));
            sortTypes[sortType]['decend'] = true;
          }
          lastSortType = sortType;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size uiSize = MediaQuery.of(context).size;
    double uiHeight = uiSize.height;
    double uiWidth = uiSize.width;

    return Scaffold(
        appBar: AppBar(
            title: const Text('Restore Data List'),
            backgroundColor: const Color.fromARGB(255, 56, 168, 224),
            actions: [
              MenuAnchor(
                  builder: (BuildContext context, MenuController controller,
                      Widget? child) {
                    return IconButton(
                      onPressed: () {
                        if (controller.isOpen) {
                          controller.close();
                        } else {
                          controller.open();
                        }
                      },
                      icon: const Icon(Icons.sort),
                    );
                  },
                  menuChildren: List<MenuItemButton>.generate(
                    sortTypes.length,
                    (int index) {
                      String sortTypeKey = sortTypes.keys.elementAt(index);
                      return MenuItemButton(
                        onPressed: () => setState(() {
                          sortData(sortTypeKey);
                        }),
                        child: Row(children: [
                          Text(sortTypeKey),
                          if (sortTypes[sortTypeKey]['decend'])
                            const Icon(Icons.arrow_downward, size: 14)
                          else
                            const Icon(Icons.arrow_upward, size: 14)
                        ]),
                      );
                    },
                  ))
            ]),
        body: SafeArea(
            child: Scrollbar(
                thumbVisibility: false,
                thickness: 5,
                radius: const Radius.circular(10),
                controller: scrollContrl,
                scrollbarOrientation: ScrollbarOrientation.right,
                child: SingleChildScrollView(
                    child: StickyHeader(
                        header: Row(children: [
                          for (final sortType in sortTypes.keys)
                            Container(
                                width: uiWidth * 0.5,
                                height: uiHeight * 0.04,
                                color: Colors.grey,
                                child: Center(
                                    child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                      Text(sortType,
                                          style: const TextStyle(fontSize: 17)),
                                      if (sortType == lastSortType)
                                        if (sortTypes[sortType]['decend'])
                                          const Icon(
                                              CupertinoIcons
                                                  .arrowtriangle_down_fill,
                                              size: 17)
                                        else
                                          const Icon(
                                              CupertinoIcons
                                                  .arrowtriangle_up_fill,
                                              size: 17)
                                      else
                                        Container()
                                    ])))
                        ]),
                        content: RefreshIndicator(
                            onRefresh: () async {
                              getRestoreDataList();
                            },
                            child: Column(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(top: 0),
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        controller: scrollContrl,
                                        padding: EdgeInsets.only(
                                            top: uiHeight * 0.03),
                                        itemCount: restoreDataList.length,
                                        itemBuilder: (context, index) {
                                          return Dismissible(
                                              onDismissed: (DismissDirection
                                                  dismissDirection) {
                                                setState(() {
                                                  restoreDataList
                                                      .removeAt(index);
                                                });
                                              },
                                              confirmDismiss:
                                                  (direction) async {
                                                return await showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return DeleteDialog(
                                                          restoreFileName:
                                                              restoreDataList[
                                                                      index]
                                                                  ['name']);
                                                    }).then((value) {
                                                  setState(() {
                                                    restoreDataList
                                                        .removeAt(index);
                                                  });
                                                  return null;
                                                });
                                              },
                                              direction:
                                                  DismissDirection.endToStart,
                                              background: Container(
                                                color: Colors.red,
                                              ),
                                              key: Key(index.toString()),
                                              child: Row(children: [
                                                Container(
                                                    width: uiWidth * 0.6,
                                                    decoration:
                                                        const BoxDecoration(
                                                      border: Border(
                                                        bottom: BorderSide(
                                                            color: Colors.grey),
                                                      ),
                                                    ),
                                                    child: ListTile(
                                                        title: Text(
                                                            DateConverter
                                                                .dateForDisplay(
                                                                    restoreDataList[
                                                                            index]
                                                                        [
                                                                        'name']),
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                        onTap: () async {
                                                          return await showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return RestoreDialog(
                                                                    restoreTarget:
                                                                        restoreDataList[index]
                                                                            [
                                                                            'name']);
                                                              });
                                                        })),
                                                Container(
                                                    width: uiWidth * 0.4,
                                                    decoration:
                                                        const BoxDecoration(
                                                      border: Border(
                                                        bottom: BorderSide(
                                                            color: Colors.grey),
                                                      ),
                                                    ),
                                                    child: ListTile(
                                                        title: Text(
                                                            UnitConvert.fileSizeConvert(
                                                                restoreDataList[
                                                                        index]
                                                                    ['size']),
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                        onTap: () async {
                                                          return await showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return RestoreDialog(
                                                                    restoreTarget:
                                                                        restoreDataList[index]
                                                                            [
                                                                            'name']);
                                                              });
                                                        }))
                                              ]));
                                        }))
                              ],
                            )))))));
  }
}
