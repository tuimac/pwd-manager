import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:src/services/fileio.dart';
import 'package:src/widgets/listPassword/deleteDialog.dart';
import 'package:src/widgets/listPassword/subMenuDrawer.dart';

class ListItems extends StatefulWidget {
  const ListItems({Key? key}) : super(key: key);

  @override
  State<ListItems> createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  late Map<String, dynamic> data = {};
  late List listData = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    await FileIO.getData.then((value) {
      setState(() {
        data = value;
        listData = data['passwords'].keys.toList();
      });
    });
    log(data.toString());
  }

  void filterList(String searchWord) {
    setState(() {
      List tmpListData = data['passwords'].keys.toList();
      listData = tmpListData
          .where(
              (item) => item.toLowerCase().contains(searchWord.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size uiSize = MediaQuery.of(context).size;
    double uiHeight = uiSize.height;
    double uiWidth = uiSize.width;

    return Scaffold(
        appBar: AppBar(
            title: const Text('Password Manager'),
            backgroundColor: const Color.fromARGB(255, 56, 168, 224)),
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
                                        fontSize: 15, color: Colors.black))))));
              } else if (snapshot.hasData) {
                return SizedBox(
                    height: uiHeight,
                    child: SingleChildScrollView(
                        child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          onChanged: (input) {
                            filterList(input);
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
                            height: uiHeight * 0.6,
                            child: RefreshIndicator(
                              onRefresh: () async {
                                getData();
                              },
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  padding:
                                      EdgeInsets.only(top: uiHeight * 0.03),
                                  itemCount: listData.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      color: const Color.fromARGB(
                                          255, 196, 228, 232),
                                      child: Dismissible(
                                          onDismissed: (DismissDirection
                                              dismissDirection) {
                                            setState(() {});
                                          },
                                          confirmDismiss: (direction) async {
                                            return await showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return DeleteDialog(
                                                      data: data,
                                                      primaryKey:
                                                          listData[index],
                                                      getData: getData);
                                                });
                                          },
                                          direction:
                                              DismissDirection.endToStart,
                                          background: Container(
                                            color: Colors.red,
                                          ),
                                          key:
                                              ValueKey<String>(listData[index]),
                                          child: ListTile(
                                              title: Text(listData[index]),
                                              onTap: () {
                                                String tmpData =
                                                    jsonEncode(data);
                                                String primaryKey =
                                                    listData[index];
                                                GoRouter.of(context)
                                                    .push(
                                                        '/editpwd/$tmpData/$primaryKey')
                                                    .then((value) => getData());
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
            String tmpData = jsonEncode(data);
            GoRouter.of(context)
                .push('/createpwd/$tmpData')
                .then((value) => getData());
          },
        ),
        drawer: SubMenuDrawer(data: data, getData: getData));
  }
}
