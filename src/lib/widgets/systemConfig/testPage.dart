import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late Map<String, dynamic> config = {};

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
            title:
                const Text('Test Page', style: TextStyle(color: Colors.white)),
            backgroundColor: const Color.fromARGB(255, 56, 168, 224)),
        body: Container());
  }
}
