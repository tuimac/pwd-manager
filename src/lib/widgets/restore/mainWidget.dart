// ignore: file_names
import 'package:flutter/material.dart';
import 'package:src/services/fileio.dart';

class Restore extends StatefulWidget {
  const Restore({Key? key}) : super(key: key);

  @override
  State<Restore> createState() => _RestoreState();
}

class _RestoreState extends State<Restore> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size uiSize = MediaQuery.of(context).size;
    double uiHeight = uiSize.height;

    return Scaffold(
        appBar: AppBar(
            title: const Text('Restore'),
            backgroundColor: const Color.fromARGB(255, 56, 168, 224)),
        body: SizedBox());
  }
}
