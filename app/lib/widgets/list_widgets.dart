import 'dart:async';

import 'package:flutter/material.dart';
import '../services/s3.dart';
import 'dart:developer';

class ListItems extends StatefulWidget {
  const ListItems({Key? key}) : super(key: key);

  @override
  State<ListItems> createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  late Future<dynamic> _get_password_future;

  @override
  void initState() {
    super.initState();
    _get_password_future = getPassowrdFile();
  }

  Future getPassowrdFile() {
    return Future(() async {
      return S3Service.getPasswordFile();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size ui_size = MediaQuery.of(context).size;
    double ui_height = ui_size.height;
    double ui_width = ui_size.width;

    return Scaffold(
        appBar: AppBar(title: const Text('Password Manager')),
        body: SizedBox(
            height: ui_height,
            child: SingleChildScrollView(
                child: Column(children: [
              Container(
                padding: EdgeInsets.only(
                    right: ui_width * 0.1, left: ui_width * 0.1),
                height: ui_height * 0.6,
                child: ListView.builder(
                    itemCount: _password_list.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          subtitle: Text(_password_list['passwords']
                                  [index.toString()]['name']
                              .toString()),
                          title: Text(_password_list['passwords']
                              [index.toString()]['name']),
                        ),
                      );
                    }),
              )
            ]))));
  }
}
