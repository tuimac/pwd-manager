import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:src/config/config.dart';
import 'package:src/services/configFileIO.dart';
import 'package:src/services/dataFileIO.dart';
import 'package:src/services/logFileIo.dart';
import 'package:src/widgets/listPassword/deleteDialog.dart';
import 'package:src/widgets/listPassword/subMenuDrawer.dart';

class ListPasswords extends StatefulWidget {
  const ListPasswords({super.key});

  @override
  State<ListPasswords> createState() => _ListPasswordsState();
}

class _ListPasswordsState extends State<ListPasswords> {
  late Map<String, dynamic> data = {};
  late bool dataIsEmpty = true;
  late Map<String, dynamic> config = {};
  late List dataList = [];
  late String filterWord = '';

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {
    DataFileIO.getData().then((dataResult) {
      ConfigFileIO.getConfig().then((configResult) {
        setState(() {
          data = dataResult;
          dataIsEmpty = false;
          config = configResult;
          filterList();
          sortData();
        });
      });
    });
  }

  void filterList() {
    setState(() {
      List tmpdataList = data.keys.toList();
      dataList = tmpdataList
          .where(
              (item) => item.toLowerCase().contains(filterWord.toLowerCase()))
          .toList();
    });
  }

  void sortData() {
    try {
      LogFileIO.logging(data.toString());
      setState(() {
        switch (config['sort_type']['type']) {
          case 'Name':
            if (config['sort_type']['state']) {
              dataList.sort((a, b) => a.compareTo(b));
            } else {
              dataList.sort((a, b) => b.compareTo(a));
            }
            break;
          case 'Modify Timestamp':
            if (config['sort_type']['state']) {
              dataList.sort((a, b) => data[a]['modify_timestamp']
                  .compareTo(data[b]['modify_timestamp']));
            } else {
              dataList.sort((a, b) => data[b]['modify_timestamp']
                  .compareTo(data[a]['modify_timestamp']));
            }
            break;
        }
      });
      LogFileIO.logging(data.toString());
    } catch (e) {
      LogFileIO.logging(e.toString());
    }
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
                      menuChildren: config.isEmpty
                          ? List.empty()
                          : List<MenuItemButton>.generate(
                              Config.sortTypeList.length,
                              (int index) {
                                String sortTypeKey = Config.sortTypeList[index];
                                return MenuItemButton(
                                  onPressed: () {
                                    setState(() {
                                      if (config['sort_type']['type'] ==
                                          Config.sortTypeList[index]) {
                                        config['sort_type']['state'] =
                                            !config['sort_type']['state'];
                                      } else {
                                        config['sort_type']['type'] =
                                            Config.sortTypeList[index];
                                        config['sort_type']['state'] = false;
                                      }
                                      sortData();
                                      ConfigFileIO.saveConfig(config);
                                    });
                                  },
                                  child: Row(children: <Widget>[
                                    Text(sortTypeKey),
                                    if (config['sort_type']['type'] ==
                                        Config.sortTypeList[index])
                                      if (config['sort_type']['state'])
                                        const Icon(Icons.arrow_downward,
                                            size: 14)
                                      else
                                        const Icon(Icons.arrow_upward, size: 14)
                                  ]),
                                );
                              },
                            ))
                ]),
            body: dataIsEmpty || config.isEmpty
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
                                            setState(() {
                                              dataList.removeAt(index);
                                              getData();
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
                                                  DataFileIO.saveData(data)
                                                      .then((value) {
                                                    getData();
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
