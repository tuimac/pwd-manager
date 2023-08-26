// ignore: file_names
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:go_router/go_router.dart';
import '../../services/fileio.dart';
import 'dart:developer';

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

  Future<Map<String, dynamic>> getPassowrdFile() {
    return Future(() async {
      return FIleIO.getPassword;
    });
  }

  void openPasswordInfo(BuildContext context) {}

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
                log(jsonEncode(passwordData));
                return SizedBox(
                    height: uiHeight,
                    child: SingleChildScrollView(
                        child: Column(children: [
                      Container(
                        padding: EdgeInsets.only(
                            right: uiWidth * 0.1, left: uiWidth * 0.1),
                        height: uiHeight * 0.6,
                        child: ListView.builder(
                            padding: const EdgeInsets.only(top: 30),
                            itemCount: passwordData['passwords'].length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                    subtitle: Text(passwordData['passwords']
                                            [index.toString()]['name']
                                        .toString()),
                                    title: Text(passwordData['passwords']
                                        [index.toString()]['name']),
                                    onTap: () {
                                      String passData = jsonEncode(
                                          passwordData['passwords']
                                              [index.toString()]);
                                      GoRouter.of(context)
                                          .push('/editpwd/$passData');
                                    }),
                              );
                            }),
                      )
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
            GoRouter.of(context).push('/createpwd/$passData');
          },
        ));
  }
}

mixin passData {}
