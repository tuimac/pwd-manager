import 'package:flutter/material.dart';

class ListItems extends StatelessWidget {
  const ListItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Password Manager')),
      body: const Center(
          child: Column(
        children: <Widget>[Text('test', style: TextStyle(color: Colors.white))],
      )),
    );
  }
}
