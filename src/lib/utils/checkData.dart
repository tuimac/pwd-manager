import 'package:src/config/config.dart';
import 'package:src/services/fileio.dart';
import 'dart:io';
import 'dart:developer';

class CheckData {
  static Map<String, dynamic> checkDataContent(Map<String, dynamic> data) {
    // Data key check
    if (!data['settings'].containsKey('auto_backup')) {
      log(data.toString());
      data['settings']['auto_backup'] = false;
    }
    // System log level
    if (!data['settings'].containsKey('log_level')) {
      data['settings']['log_level'] = 'none';
    }
    // Biometrics Authentication
    if (!data['settings'].containsKey('bio_auth')) {
      data['settings']['bio_auth'] = false;
    }
    return data;
  }

  static Future checkDataPath() async {
    // Check data directory
    if (!await FileIO.isExist('datadir')) {
      await Directory('${await FileIO.baseDirInfo}/${Config.dataDir}')
          .create(recursive: true);
    }
    // If there is no back up directory.
    if (!await FileIO.isExist('backup')) {
      await Directory('${await FileIO.baseDirInfo}/${Config.autoBackupDir}')
          .create(recursive: true);
    }
    // If there is no log directory.
    if (!await FileIO.isExist('log')) {
      await Directory('${await FileIO.baseDirInfo}/${Config.loggingDir}')
          .create(recursive: true);
    }
  }
}
