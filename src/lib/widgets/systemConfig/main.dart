import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:local_auth/local_auth.dart';
import 'package:src/services/configFileIO.dart';
import 'package:src/services/logFileIo.dart';

class SystemConfig extends StatefulWidget {
  const SystemConfig({super.key});

  @override
  State<SystemConfig> createState() => _SystemConfigState();
}

class _SystemConfigState extends State<SystemConfig> {
  late Map<String, dynamic> config = {};

  @override
  void initState() {
    super.initState();
    ConfigFileIO.getConfig().then((result) => setState(() {
          config = result;
        }));
  }

  Future<void> configBioauth() async {
    final LocalAuthentication auth = LocalAuthentication();
    try {
      await auth.getAvailableBiometrics().then((biometricTypes) {
        if (biometricTypes.isEmpty) {
          throw PlatformException(
              code: '400',
              message:
                  'Biometric authentication not implemented on this device.');
        }
      });
      await auth.isDeviceSupported().then((bool isSupported) {
        if (!isSupported) {
          throw PlatformException(
              code: '401',
              message:
                  'Biometric authentication not configured on this device.');
        }
      });
      await auth.canCheckBiometrics.then((bool canCheck) {
        if (!canCheck) {
          throw PlatformException(
              code: '402',
              message:
                  'Biometric authentication not configured on this device.');
        }
      });

      setState(() {
        config['bio_auth'] = !config['bio_auth'];
      });
      await ConfigFileIO.saveConfig(config);
    } on PlatformException catch (e) {
      LogFileIO.logging(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size uiSize = MediaQuery.of(context).size;
    double uiHeight = uiSize.height;

    return Scaffold(
        appBar: AppBar(
            title: const Text('Settings'),
            backgroundColor: const Color.fromARGB(255, 56, 168, 224)),
        body: config.isEmpty
            ? Center(
                child: LoadingAnimationWidget.discreteCircle(
                color: Colors.white,
                size: MediaQuery.of(context).size.height * 0.2,
              ))
            : SizedBox(
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
                    onChanged: (value) async {
                      await configBioauth();
                    },
                  )
                ]))));
  }
}
