// ignore: file_names
import 'package:flutter/material.dart';

class ManagePassword extends StatefulWidget {
  const ManagePassword({Key? key}) : super(key: key);

  @override
  State<ManagePassword> createState() => _ManagePasswordState();
}

class _ManagePasswordState extends State<ManagePassword> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size uiSize = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(title: const Text('Password Manager')),
        body: const Center(
            child: Text('test',
                style: TextStyle(fontSize: 20, color: Colors.white))));
  }
}
