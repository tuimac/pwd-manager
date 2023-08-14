import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../services/s3.dart';

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

  Future<Map<String, dynamic>> getPassowrdFile() {
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
        body: FutureBuilder<dynamic>(
            future: _get_password_future,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                final error = snapshot.error;
                return Text(
                  'Errro: $error',
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                );
              } else if (snapshot.hasData) {
                var password_data = snapshot.data!['passwords'];
                return SizedBox(
                    height: ui_height,
                    child: SingleChildScrollView(
                        child: Column(children: [
                      Container(
                        padding: EdgeInsets.only(
                            right: ui_width * 0.1, left: ui_width * 0.1),
                        height: ui_height * 0.6,
                        child: ListView.builder(
                            itemCount: password_data.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  subtitle: Text(password_data[index.toString()]
                                          ['name']
                                      .toString()),
                                  title: Text(
                                      password_data[index.toString()]['name']),
                                ),
                              );
                            }),
                      )
                    ])));
              } else {
                return LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.white,
                  size: 200,
                );
              }
            }));
  }
}
