// ignore: file_names
import 'dart:convert';

import 'package:flutter/material.dart';

class CreatePassword extends StatefulWidget {
  final Map<String, dynamic> data;
  const CreatePassword({Key? key, required this.data}) : super(key: key);

  @override
  State<CreatePassword> createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
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
            child: Text(data['passwords'],
                style: const TextStyle(fontSize: 20, color: Colors.white))));
  }
}
