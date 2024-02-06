// ignore: file_names
import 'package:flutter/material.dart';
import 'package:src/services/dataFileIO.dart';

class SystemConfig extends StatefulWidget {
  final Map<String, dynamic> data;
  const SystemConfig({Key? key, required this.data}) : super(key: key);

  @override
  State<SystemConfig> createState() => _SystemConfigState();
}

class _SystemConfigState extends State<SystemConfig> {
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
            title: const Text('Settings'),
            backgroundColor: const Color.fromARGB(255, 56, 168, 224)),
        body: SizedBox(
            height: uiHeight,
            child: SingleChildScrollView(
                child: Column(children: [
              SwitchListTile(
                title: const Text('Auto Backup',
                    style: TextStyle(color: Colors.white)),
                subtitle: const Text(
                    'Backup the data when change the password status.',
                    style: TextStyle(color: Colors.white, fontSize: 12)),
                value: data['settings']['auto_backup']!,
                onChanged: (value) {
                  setState(() {
                    data['settings']['auto_backup'] = value;
                  });
                  DataFileIO.saveData(data);
                },
              ),
              SwitchListTile(
                title: const Text('Biometrics Authentication',
                    style: TextStyle(color: Colors.white)),
                subtitle: const Text(
                    'Authentication by FaceID or Finger Print and so on.',
                    style: TextStyle(color: Colors.white, fontSize: 12)),
                value: data['settings']['bio_auth']!,
                onChanged: (value) {
                  setState(() {
                    data['settings']['bio_auth'] = value;
                  });
                  DataFileIO.saveData(data);
                },
              )
            ]))));
  }
}
