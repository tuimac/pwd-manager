import 'package:flutter/material.dart';
import '../services/s3.dart';

class ListItems extends StatelessWidget {
  const ListItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Password Manager')),
        body: Center(
          child: FutureBuilder<String>(
              future: S3Service.getPasswordFile(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                <Widget>[const Text('fail')]
              }),
        ));
  }
}

class $ {}
