import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Config {
  static const String dataExtension = '.json';
  static Map<String, dynamic> dataTemplate = {};
  static Map<String, dynamic> configTemplate = {};

  static Future<String> get getBaseDir async {
    if (Platform.isAndroid) {
      return (await getApplicationDocumentsDirectory()).path;
    } else {
      return (await getLibraryDirectory()).path;
    }
  }

  static Future<String> get getDataPath async {
    return '${await getBaseDir}/data/latest.json';
  }

  static Future<String> get getDataDir async {
    return '${await getBaseDir}/data/';
  }

  static Future<String> get getConfigPath async {
    return '${await getBaseDir}/config/config.json';
  }

  static Future<String> get getConfigDir async {
    return '${await getBaseDir}/config/';
  }

  static Future<String> get getLogPath async {
    return '${await getBaseDir}/log/latest.log';
  }

  static Future<String> get getLogDir async {
    return '${await getBaseDir}/log/';
  }

  static Future<String> get getBackupDir async {
    return '${await getBaseDir}/backup/';
  }

  static Future<String> get getPasscodePath async {
    return '${await getBaseDir}/passcode.json';
  }
}
