// ignore: file_names
import 'package:flutter/material.dart';

class EditPassword extends StatefulWidget {
  final Map<String, dynamic> data;
  const EditPassword({Key? key, required this.data}) : super(key: key);

  @override
  State<EditPassword> createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  late Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();
    data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Password Manager')),
        body: Center(
            child: Text(data['name'],
                style: const TextStyle(fontSize: 20, color: Colors.white))));
  }
}
