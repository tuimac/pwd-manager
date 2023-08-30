// ignore: file_names
import 'package:flutter/material.dart';

class SystemConfig extends StatefulWidget {
  final Map<String, dynamic> data;
  const SystemConfig({Key? key, required this.data}) : super(key: key);

  @override
  State<SystemConfig> createState() => _SystemConfigState();
}

class _SystemConfigState extends State<SystemConfig> {
  late Map<String, dynamic> passwordData;

  @override
  void initState() {
    super.initState();
    passwordData = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    Size uiSize = MediaQuery.of(context).size;
    double uiHeight = uiSize.height;

    return Scaffold(
        appBar: AppBar(title: const Text('Password Manager')),
        body: SizedBox(
            height: uiHeight,
            child: SingleChildScrollView(
                child: Column(children: [
              CheckboxListTile(
                title: const Text('Auto Backup',
                    style: TextStyle(color: Colors.white)),
                value: passwordData['setting']['auto_backup']!,
                onChanged: (value) {
                  setState(() {
                    passwordData['setting']['auto_backup'] = value;
                  });
                },
              )
            ]))));
  }
}
