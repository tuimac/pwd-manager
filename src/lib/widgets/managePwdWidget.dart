// ignore: file_names
import 'package:flutter/material.dart';

class ManagePassword extends StatefulWidget {
  final Map<String, dynamic> data;
  const ManagePassword({Key? key, required this.data}) : super(key: key);

  @override
  State<ManagePassword> createState() => _ManagePasswordState();
}

class _ManagePasswordState extends State<ManagePassword> {
  late Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();
    data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    Size uiSize = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(title: const Text('Password Manager')),
        body: Center(
            child: Text(data['name'],
                style: const TextStyle(fontSize: 20, color: Colors.white))));
  }
}
