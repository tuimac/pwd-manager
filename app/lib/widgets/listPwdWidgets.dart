// ignore: file_names
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:go_router/go_router.dart';
import '../services/s3.dart';

class ListItems extends StatefulWidget {
  const ListItems({Key? key}) : super(key: key);

  @override
  State<ListItems> createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  late Future<dynamic> _getPasswordFuture;

  @override
  void initState() {
    super.initState();
    _getPasswordFuture = getPassowrdFile();
  }

  Future<Map<String, dynamic>> getPassowrdFile() {
    return Future(() async {
      return S3Service.getPasswordFile();
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
                return Text(
                  'Errro: $error',
                  style: const TextStyle(fontSize: 20, color: Colors.red),
                );
              } else if (snapshot.hasData) {
                var passwordData = snapshot.data!['passwords'];
                return SizedBox(
                    height: uiHeight,
                    child: SingleChildScrollView(
                        child: Column(children: [
                      Container(
                        padding: EdgeInsets.only(
                            right: uiWidth * 0.1, left: uiWidth * 0.1),
                        height: uiHeight * 0.6,
                        child: ListView.builder(
                            itemCount: passwordData.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                    subtitle: Text(
                                        passwordData[index.toString()]['name']
                                            .toString()),
                                    title: Text(
                                        passwordData[index.toString()]['name']),
                                    onTap: () =>
                                        GoRouter.of(context).go('/managepwd')),
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
            }));
  }
}
