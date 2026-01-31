import 'package:flutter/foundation.dart';
import 'package:src/config/config.dart';
import 'package:src/utils/dateFormat.dart';
import 'package:src/services/fileio.dart';
import 'dart:io';
import 'dart:developer';

class CheckData {
  static Map<String, dynamic> checkDataContent(Map<String, dynamic> data) {
    // Data key check
    if (!data['settings'].containsKey('auto_backup')) {
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
    // Sort configuration
    if (!data['settings'].containsKey('sort_type')) {
      data['settings']['sort_type'] = 'Recent Access';
    }
    // Auto Password Generate Rule
    if (!data['settings'].containsKey('auto_pwd_gen_rule')) {
      data['settings']['auto_pwd_gen_rule'] = {
        'length': 8,
        'min_rules': {
          'min_lower_char_length': 1,
          'min_upper_char_length': 1,
          'min_num_length': 1,
          'min_special_length': 1
        }
      };
    }
    // Inside of data
    for (var key in data['passwords'].keys.toList()) {
      if (!data['passwords'][key].containsKey('watch_time')) {
        data['passwords'][key]['watch_time'] = DateConverter.getNow();
      }
      if (!data['passwords'][key].containsKey('create_time')) {
        data['passwords'][key]['create_time'] = DateConverter.getNow();
      }
    }
    return data;
  }

  static void checkDataPath() async {
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
