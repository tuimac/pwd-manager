// ignore: file_names
import 'package:flutter/material.dart';

class SystemConfig extends StatefulWidget {
  const SystemConfig({Key? key}) : super(key: key);

  @override
  State<SystemConfig> createState() => _SystemConfigState();
}

class _SystemConfigState extends State<SystemConfig> {
  late Map<String, dynamic> passwordData;
  late int dataIndex;
  late bool passwordVisible;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Password Manager')),
        body: const Center(child: Text('ddd')));
  }
}
