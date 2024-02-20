import 'package:src/config/config.dart';
import 'package:src/services/configFileIo.dart';
import 'package:src/services/dataFileIo.dart';
import 'package:src/services/logFileIo.dart';
import 'package:src/services/passcodeFileIo.dart';
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
    // Sort Type
    if (!config.containsKey('sort_type')) {
      config['sort_type'] = {'type': 'Modify Timestamp', 'state': false};
    }
    return config;
  }

  static Map<String, dynamic> checkDataContent(Map<String, dynamic> data) {
    for (String primaryKey in data.keys.toList()) {
      if (!data[primaryKey].containsKey('create_timestamp')) {
        data[primaryKey]['create_timestamp'] = DateTime.now().toIso8601String();
      }
      if (!data[primaryKey].containsKey('watch_timestamp')) {
        data[primaryKey]['watch_timestamp'] = DateTime.now().toIso8601String();
      }
      if (!data[primaryKey].containsKey('modify_timestamp')) {
        data[primaryKey]['modify_timestamp'] = DateTime.now().toIso8601String();
      }
    }
    return data;
  }

  static Future checkFilePath() async {
    // Check passcode file
    if (!await File(await Config.getPasscodePath).exists()) {
      await PasscodeIO.registerPasscode();
    }
    // Check data file
    if (!await File(await Config.getDataPath).exists()) {
      await Directory(await Config.getDataDir).create(recursive: true);
      await DataFileIO.saveData(Config.dataTemplate);
    }
    // Check config file
    if (!await File(await Config.getConfigPath).exists()) {
      await Directory(await Config.getConfigDir).create(recursive: true);
      await ConfigFileIO.saveConfig(Config.configTemplate);
    }
    // Check backup directory
    if (!await File(await Config.getBackupDir).exists()) {
      await Directory(await Config.getBackupDir).create(recursive: true);
    }
    // Check log file
    if (!await File(await Config.getLogPath).exists()) {
      await Directory(await Config.getLogDir).create(recursive: true);
      await LogFileIO.logging('');
    }
  }
}
