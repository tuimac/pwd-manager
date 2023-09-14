import 'package:src/config/config.dart';
import 'package:src/services/fileio.dart';
import 'dart:io';
import 'dart:developer';

Map<String, dynamic> _checkData(Map<String, dynamic> data) {
  // Data key check
  if (!data['settings'].containsKey('auto_backup')) {
    data['settings']['auto_backup'] = false;
  }
  if (!data['settings'].containsKey('log_level')) {
    data['settings']['log_level'] = 'none';
  }
  // Pass Phrase check
  if (!data.containsKey('pass_code')) {
    data['pass_code'] = '';
  }
  return data;
}

Future<Map<String, dynamic>> sanitizeData(
    Map<String, dynamic> returnData) async {
  // Check data directory
  if (await File('${await FileIO.baseDirInfo}/${Config.dataDir}').exists()) {
    if (await File(
            '${await FileIO.baseDirInfo}/${Config.dataDir}/${Config.latestData}')
        .exists()) {
      returnData = await FileIO.getData;
    } else {
      returnData = _checkData(Config.dataTemplate);
      await FileIO.saveData(returnData);
    }
  } else {
    await Directory('${await FileIO.baseDirInfo}/${Config.dataDir}')
        .create(recursive: true);
    returnData = _checkData(Config.dataTemplate);
    await FileIO.saveData(returnData);
  }
  // If there is no back up directory.
  if (!await File('${await FileIO.baseDirInfo}/${Config.autoBackupDir}')
      .exists()) {
    await Directory('${await FileIO.baseDirInfo}/${Config.autoBackupDir}')
        .create(recursive: true);
  }
  // If there is no back up directory.
  if (!await File('${await FileIO.baseDirInfo}/${Config.loggingDir}')
      .exists()) {
    await Directory('${await FileIO.baseDirInfo}/${Config.loggingDir}')
        .create(recursive: true);
  }
  return _checkData(returnData);
}
