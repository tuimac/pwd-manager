import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import '../services/s3.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ListItems extends StatefulWidget {
  const ListItems({Key? key}) : super(key: key);

  @override
  State<ListItems> createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Password Manager')),
        body: Center(
            child: FutureBuilder<String?>(
                future: S3Service.getPasswordFile(),
                builder: (context, snapshot) {
                  List<Widget> children;
                  if (snapshot.hasError) {
                    final error = snapshot.error;
                    return Text(
                      'Errro: $error',
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    );
                  } else if (snapshot.hasData) {
                    final result = convert.json.decode(snapshot.data!)
                        as Map<String, dynamic>;

                    children = <Widget>[
                      Container(
                          height: 125,
                          padding: const EdgeInsets.all(4),
                          child: ListView(children: <Widget>[
                            Container(
                              height: 50,
                              color: Colors.blue[600],
                              child: Text('Item 1'),
                            )
                          ]))
                    ];
                  } else {
                    return LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.white,
                      size: 200,
                    );
                  }
                })));
  }
}

class $ {}
