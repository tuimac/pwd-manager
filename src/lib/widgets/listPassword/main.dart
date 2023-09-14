import 'dart:convert';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:src/utils/dateFormat.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:src/services/fileio.dart';
import 'package:src/widgets/listPassword/deleteDialog.dart';
import 'package:src/widgets/listPassword/subMenuDrawer.dart';

class ListPasswords extends StatefulWidget {
  const ListPasswords({Key? key}) : super(key: key);

  @override
  State<ListPasswords> createState() => _ListPasswordsState();
}

class _ListPasswordsState extends State<ListPasswords> {
  late Map<String, dynamic> data = {};
  late List dataList = [];
  late String filterWord = '';
  Map<String, dynamic> sortTypes = {'Name': false};

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    await FileIO.getData.then((value) {
      setState(() {
        data = value;
        dataList = data['passwords'].keys.toList();
      });
    });
    filterList();
  }

  void filterList() {
    setState(() {
      List tmpdataList = data['passwords'].keys.toList();
      dataList = tmpdataList
          .where(
              (item) => item.toLowerCase().contains(filterWord.toLowerCase()))
          .toList();
    });
  }

  void sortData(String sortType) {
    setState(() {
      switch (sortType) {
        case 'Name':
          if (sortTypes[sortType]) {
            dataList.sort();
            sortTypes[sortType] = false;
          } else {
            dataList.sort();
            dataList = List.from(dataList.reversed);
            sortTypes[sortType] = true;
          }
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size uiSize = MediaQuery.of(context).size;
    double uiHeight = uiSize.height;
    double uiWidth = uiSize.width;

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            appBar: AppBar(
                title: const Text('Password Manager'),
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
                              if (sortTypes[sortTypeKey])
                                const Icon(Icons.arrow_downward, size: 14)
                              else
                                const Icon(Icons.arrow_upward, size: 14)
                            ]),
                          );
                        },
                      ))
                ]),
            body: FutureBuilder<dynamic>(
                future: FileIO.getData,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    final error = snapshot.error;
                    return Center(
                        child: SizedBox(
                            width: uiWidth * 0.8,
                            height: uiHeight * 0.2,
                            child: Card(
                                margin: const EdgeInsets.all(30),
                                color: Colors.grey,
                                elevation: 10,
                                shadowColor: Colors.black,
                                child: Center(
                                    child: Text('Error: $error',
                                        style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.black))))));
                  } else if (snapshot.hasData) {
                    return SizedBox(
                        height: uiHeight,
                        child: SingleChildScrollView(
                            child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              onChanged: (input) {
                                setState(() {
                                  filterWord = input;
                                });
                                filterList();
                              },
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 216, 212, 243)),
                              decoration: const InputDecoration(
                                  labelText: 'Search',
                                  labelStyle: TextStyle(
                                      color:
                                          Color.fromARGB(255, 216, 212, 243)),
                                  hintText: 'Search',
                                  hintStyle: TextStyle(
                                      color:
                                          Color.fromARGB(255, 159, 156, 179)),
                                  prefixIcon: Icon(Icons.search),
                                  prefixIconColor: Colors.white),
                            ),
                          ),
                          Column(children: [
                            Container(
                                padding: EdgeInsets.only(
                                    right: uiWidth * 0.1, left: uiWidth * 0.1),
                                height: uiHeight * 0.7,
                                child: RefreshIndicator(
                                  onRefresh: () async {
                                    getData();
                                  },
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      padding:
                                          EdgeInsets.only(top: uiHeight * 0.03),
                                      itemCount: dataList.length,
                                      itemBuilder: (context, index) {
                                        return Card(
                                          color: const Color.fromARGB(
                                              255, 196, 228, 232),
                                          child: Dismissible(
                                              onDismissed: (DismissDirection
                                                  dismissDirection) {
                                                setState(() {
                                                  dataList.removeAt(index);
                                                  getData();
                                                });
                                              },
                                              confirmDismiss:
                                                  (direction) async {
                                                return await showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return DeleteDialog(
                                                          data: data,
                                                          primaryKey:
                                                              dataList[index],
                                                          getData: getData);
                                                    });
                                              },
                                              direction:
                                                  DismissDirection.endToStart,
                                              background: Container(
                                                color: Colors.red,
                                              ),
                                              key: ValueKey<String>(
                                                  dataList[index]),
                                              child: ListTile(
                                                  title: Text(dataList[index]),
                                                  onTap: () {
                                                    GoRouter.of(context)
                                                        .push(
                                                            '/editpwd/${dataList[index]}',
                                                            extra: data)
                                                        .then((value) =>
                                                            getData());
                                                  })),
                                        );
                                      }),
                                ))
                          ])
                        ])));
                  } else {
                    return Center(
                        child: LoadingAnimationWidget.discreteCircle(
                      color: Colors.white,
                      size: uiWidth * 0.2,
                    ));
                  }
                }),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                GoRouter.of(context)
                    .push('/createpwd', extra: data)
                    .then((value) => getData());
              },
            ),
            drawer: SubMenuDrawer(data: data, getData: getData)));
  }
}