import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:src/services/fileio.dart';
import 'package:src/utils/cipher.dart';
import 'package:src/widgets/listPassword/deleteDialog.dart';
import 'package:src/widgets/listPassword/subMenuDrawer.dart';

class ListPasswords extends StatefulWidget {
  final Map<String, dynamic> data;
  const ListPasswords({Key? key, required this.data}) : super(key: key);

  @override
  State<ListPasswords> createState() => _ListPasswordsState();
}

class _ListPasswordsState extends State<ListPasswords> {
  late Map<String, dynamic> data;
  late List dataList = [];
  late String filterWord = '';
  Map<String, bool> sortInfo = {'Name': true, 'Recent Access': true};

  @override
  void initState() {
    super.initState();
    setState(() {
      data = widget.data;
      dataList = data['passwords'].keys.toList();
      sortData(data['settings']['sort_type']);
    });
  }

  void getData() async {
    await FileIO.getData().then((value) {
      setState(() {
        data = value;
        dataList = value['passwords'].keys.toList();
        sortData(data['settings']['sort_type']);
        filterList();
      });
    });
  }

  void filterList() {
    if (filterWord.isNotEmpty) {
      setState(() {
        List tmpdataList = data['passwords'].keys.toList();
        dataList = tmpdataList
            .where(
                (item) => item.toLowerCase().contains(filterWord.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        dataList = data['passwords'].keys.toList();
        sortData(data['settings']['sort_type']);
      });
    }
  }

  void sortData(String sortType) {
    setState(() {
      switch (sortType) {
        case 'Name':
          if (sortInfo[sortType]!) {
            dataList.sort();
          } else {
            dataList.sort();
            dataList = List.from(dataList.reversed);
          }
          break;
        case 'Recent Access':
          if (sortInfo[sortType]!) {
            dataList.sort(((b, a) => data['passwords'][a]['watch_time']
                .compareTo(data['passwords'][b]['watch_time'])));
          } else {
            dataList.sort(((a, b) => data['passwords'][a]['watch_time']
                .compareTo(data['passwords'][b]['watch_time'])));
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
                        sortInfo.length,
                        (int index) {
                          String sortTypeKey = sortInfo.keys.elementAt(index);
                          return MenuItemButton(
                            onPressed: () => setState(() {
                              setState(() {
                                data['settings']['sort_type'] = sortTypeKey;
                                sortInfo[sortTypeKey] = !sortInfo[sortTypeKey]!;
                              });
                              sortData(sortTypeKey);
                            }),
                            child: Row(children: [
                              Text(sortTypeKey),
                              sortTypeKey == data['settings']['sort_type']
                                  ? sortInfo[sortTypeKey]!
                                      ? const Icon(Icons.arrow_downward,
                                          size: 14)
                                      : const Icon(Icons.arrow_upward, size: 14)
                                  : Container()
                            ]),
                          );
                        },
                      ))
                ]),
            body: data.isEmpty
                ? Center(
                    child: LoadingAnimationWidget.discreteCircle(
                    color: Colors.white,
                    size: uiWidth * 0.2,
                  ))
                : SizedBox(
                    height: uiHeight,
                    child: SingleChildScrollView(
                        child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          autofocus: false,
                          onChanged: (input) {
                            setState(() {
                              filterWord = input;
                              filterList();
                            });
                          },
                          style: const TextStyle(
                              color: Color.fromARGB(255, 216, 212, 243)),
                          decoration: const InputDecoration(
                              labelText: 'Search',
                              labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 216, 212, 243)),
                              hintText: 'Search',
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 159, 156, 179)),
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
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      '${dataList[index]} deleted.')),
                                            );
                                            setState(() {
                                              data['passwords']
                                                  .remove(dataList[index]);
                                              dataList.removeAt(index);
                                              FileIO.saveData(data).then(
                                                (value) {
                                                  getData();
                                                },
                                              );
                                            });
                                          },
                                          confirmDismiss: (direction) async {
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
                                          key:
                                              ValueKey<String>(dataList[index]),
                                          child: ListTile(
                                              title: Text(dataList[index]),
                                              onTap: () {
                                                GoRouter.of(context)
                                                    .push(
                                                        '/editpwd/${dataList[index]}',
                                                        extra: data)
                                                    .then((value) {
                                                  setState(() {
                                                    FileIO.saveData(data)
                                                        .then((value) {
                                                      getData();
                                                    });
                                                  });
                                                });
                                              })),
                                    );
                                  }),
                            ))
                      ])
                    ]))),
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
