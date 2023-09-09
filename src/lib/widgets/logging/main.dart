// ignore: file_names
import 'package:flutter/material.dart';
import 'package:src/services/fileio.dart';

class Logging extends StatefulWidget {
  final Map<String, dynamic> data;
  const Logging({Key? key, required this.data}) : super(key: key);

  @override
  State<Logging> createState() => _LoggingState();
}

class _LoggingState extends State<Logging> {
  late Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();
    data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    Size uiSize = MediaQuery.of(context).size;
    double uiHeight = uiSize.height;

    return Scaffold(
        appBar: AppBar(
            title: const Text('Logging'),
            backgroundColor: const Color.fromARGB(255, 56, 168, 224)),
        body: SizedBox(
            height: uiHeight,
            child:
                SingleChildScrollView(child: Column(children: [Container()]))));
  }
}
