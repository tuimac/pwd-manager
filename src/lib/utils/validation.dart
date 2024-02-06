import 'dart:convert';
import 'package:src/config/config.dart';
import 'dart:io';

class Validation {
  static Map<String, dynamic> checkConfigContent(Map<String, dynamic> config) {
    // Data key check
    if (!config.containsKey('auto_backup')) {
      config['auto_backup'] = false;
    }
    // System log level
    if (!config.containsKey('log_level')) {
      config['log_level'] = 'none';
    }
    // Biometrics Authentication
    if (!config.containsKey('bio_auth')) {
      config['bio_auth'] = false;
    }
    return config;
  }

  static Map<String, dynamic> checkDataContent(Map<String, dynamic> data) {
    return data;
  }

  static Future checkFilePath() async {
    // Check data file
    if (!await File(await Config.getDataPath).exists()) {
      await Directory(await Config.getDataDir).create(recursive: true);
      File(await Config.getDataPath).writeAsString(
          jsonEncode(Validation.checkDataContent(Config.dataTemplate)),
          mode: FileMode.writeOnly);
    }
    // Check config file
    if (!await File(await Config.getConfigPath).exists()) {
      await Directory(await Config.getConfigDir).create(recursive: true);
      File(await Config.getConfigPath).writeAsString(
          jsonEncode(Validation.checkConfigContent(Config.configTemplate)),
          mode: FileMode.writeOnly);
    }
    // Check backup directory
    if (!await File(await Config.getBackupDir).exists()) {
      await Directory(await Config.getBackupDir).create(recursive: true);
    }
    // Check log file
    if (!await File(await Config.getLogPath).exists()) {
      await Directory(await Config.getLogDir).create(recursive: true);
      File(await Config.getLogPath).writeAsString('', mode: FileMode.writeOnly);
    }
  }
}
