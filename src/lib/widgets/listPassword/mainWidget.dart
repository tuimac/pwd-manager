// ignore: file_names
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:go_router/go_router.dart';
import '../../services/fileio.dart';
import 'package:src/widgets/listPassword/deleteDialog.dart';

class ListItems extends StatefulWidget {
  const ListItems({Key? key}) : super(key: key);

  @override
  State<ListItems> createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  late Map<String, dynamic> data;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    await FileIO.getData.then((value) {
      setState(() {
        data = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size uiSize = MediaQuery.of(context).size;
    double uiHeight = uiSize.height;
    double uiWidth = uiSize.width;

    return Scaffold(
        appBar: AppBar(title: const Text('Password Manager')),
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
                data = snapshot.data!;
                return SizedBox(
                    height: uiHeight,
                    child: SingleChildScrollView(
                        child: Column(children: [
                      Container(
                          padding: EdgeInsets.only(
                              right: uiWidth * 0.1, left: uiWidth * 0.1),
                          height: uiHeight * 0.6,
                          child: RefreshIndicator(
                            onRefresh: () async {
                              getData();
                            },
                            child: ListView.builder(
                                padding: EdgeInsets.only(top: uiHeight * 0.03),
                                itemCount: data['passwords'].length,
                                itemBuilder: (context, index) {
                                  String primaryKey =
                                      data['passwords'].keys.elementAt(index);
                                  return Card(
                                    color: const Color.fromARGB(
                                        255, 196, 228, 232),
                                    child: Dismissible(
                                        onDismissed: (DismissDirection
                                            dismissDirection) {
                                          setState(() {
                                            data['passwords']
                                                .remove(primaryKey);
                                          });
                                        },
                                        confirmDismiss: (direction) async {
                                          return await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return DeleteDialog(
                                                    data: data,
                                                    passwordIndex: index,
                                                    getData: getData);
                                              });
                                        },
                                        direction: DismissDirection.endToStart,
                                        background: Container(
                                          color: Colors.red,
                                        ),
                                        key: ValueKey<String>(primaryKey),
                                        child: ListTile(
                                            title: Text(primaryKey),
                                            onTap: () {
                                              String tmpData = jsonEncode(data);
                                              GoRouter.of(context)
                                                  .push(
                                                      '/editpwd/$tmpData/$primaryKey')
                                                  .then((value) => getData());
                                            })),
                                  );
                                }),
                          ))
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
        drawer: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: const Color.fromARGB(255, 196, 228, 232),
            ),
            child: Drawer(
                width: uiWidth * 0.6,
                child: ListView(padding: EdgeInsets.zero, children: [
                  SizedBox(
                    height: uiHeight * 0.12,
                    child: const DrawerHeader(
                      child: Center(
                          child: Text('Menu',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black))),
                    ),
                  ),
                  Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 134, 179, 185),
                      ),
                      child: ListTile(
                        title: const Text('Home'),
                        onTap: () {
                          GoRouter.of(context).pop();
                        },
                      )),
                  const Divider(height: 1, color: Colors.black),
                  Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 134, 179, 185),
                      ),
                      child: ListTile(
                        title: const Text('Setting'),
                        onTap: () {
                          String tmpData = jsonEncode(data);
                          GoRouter.of(context).pop();
                          GoRouter.of(context)
                              .push('/systemconfig/$tmpData')
                              .then((value) => getData());
                        },
                      ))
                ]))));
  }
}
