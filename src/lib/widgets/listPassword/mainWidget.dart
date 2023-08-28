// ignore: file_names
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:go_router/go_router.dart';
import '../../services/fileio.dart';

class ListItems extends StatefulWidget {
  const ListItems({Key? key}) : super(key: key);

  @override
  State<ListItems> createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  late Future<dynamic> _getPasswordFuture;
  late Map<String, dynamic> passwordData;

  @override
  void initState() {
    super.initState();
    _getPasswordFuture = getPassowrdFile();
  }

  Future<Map<String, dynamic>> getPassowrdFile() async {
    return Future(() async {
      return FIleIO.getPassword;
    });
  }

  void reloadList() {
    _getPasswordFuture = getPassowrdFile();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size uiSize = MediaQuery.of(context).size;
    double uiHeight = uiSize.height;
    double uiWidth = uiSize.width;

    return Scaffold(
        appBar: AppBar(title: const Text('Password Manager')),
        body: FutureBuilder<dynamic>(
            future: _getPasswordFuture,
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
                passwordData = snapshot.data!;
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
                              reloadList();
                            },
                            child: ListView.builder(
                                padding: EdgeInsets.only(top: uiHeight * 0.03),
                                itemCount: passwordData['passwords'].length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    color: const Color.fromARGB(
                                        255, 196, 228, 232),
                                    child: ListTile(
                                        subtitle: Text(passwordData['passwords']
                                                [index]['name']
                                            .toString()),
                                        title: Text(passwordData['passwords']
                                            [index]['name']),
                                        onTap: () {
                                          String passData =
                                              jsonEncode(passwordData);
                                          String dataIndex = index.toString();
                                          GoRouter.of(context)
                                              .push(
                                                  '/editpwd/$passData/$dataIndex')
                                              .then((value) => reloadList());
                                        }),
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
            String passData = jsonEncode(passwordData);
            GoRouter.of(context)
                .push('/createpwd/$passData')
                .then((value) => reloadList());
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
                      color: const Color.fromARGB(255, 134, 179, 185),
                      child: ListTile(
                        title: const Text('Home'),
                        onTap: () {
                          GoRouter.of(context).pop();
                        },
                      )),
                  Container(
                      color: const Color.fromARGB(255, 134, 179, 185),
                      child: ListTile(
                        title: const Text('Setting'),
                        onTap: () {
                          GoRouter.of(context)
                              .push('/systemconfig')
                              .then((value) => GoRouter.of(context).pop())
                              .then((value) => reloadList());
                        },
                      ))
                ]))));
  }
}
