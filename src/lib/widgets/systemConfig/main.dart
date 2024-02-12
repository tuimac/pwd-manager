import 'package:flutter/material.dart';
import 'package:src/services/configFileIo.dart';

class SystemConfig extends StatefulWidget {
  const SystemConfig({Key? key}) : super(key: key);

  @override
  State<SystemConfig> createState() => _SystemConfigState();
}

class _SystemConfigState extends State<SystemConfig> {
  late Map<String, dynamic> config;

  @override
  void initState() {
    super.initState();
    ConfigFileIO.getConfig().then((result) => setState(() {
          config = result;
        }));
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
                value: config['auto_backup']!,
                onChanged: (value) {
                  setState(() {
                    config['auto_backup'] = value;
                  });
                  ConfigFileIO.saveConfig(config);
                },
              ),
              SwitchListTile(
                title: const Text('Biometrics Authentication',
                    style: TextStyle(color: Colors.white)),
                subtitle: const Text(
                    'Authentication by FaceID or Finger Print and so on.',
                    style: TextStyle(color: Colors.white, fontSize: 12)),
                value: config['bio_auth']!,
                onChanged: (value) {
                  setState(() {
                    config['bio_auth'] = value;
                  });
                  ConfigFileIO.saveConfig(config);
                },
              )
            ]))));
  }
}
