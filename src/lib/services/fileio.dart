import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:src/utils/cipher.dart';
import 'package:src/config/config.dart';
import 'dart:developer';

import 'package:src/utils/dateFormat.dart';

class FileIO {
  static Future<Map<String, dynamic>> get getData async {
    try {
      final baseDirInfo = await getApplicationDocumentsDirectory();
      return jsonDecode(Cipher.decryptString(await File(
              '${baseDirInfo.path}${Config.dataDir}/${Config.latestData}')
          .readAsString()));
    } on PathNotFoundException {
      initData();
      return Config.dataTemplate;
    }
  }

  static Future saveData(data) async {
    final baseDirInfo = await getApplicationDocumentsDirectory();
    final pwdPath = '${baseDirInfo.path}${Config.dataDir}/${Config.latestData}';
    try {
      if (data['setting']['auto_backup']) {
        await File(pwdPath).copy(
            '${baseDirInfo.path}${Config.autoBackupDir}/${DateFormat('yyyy-MM-dd-HH-mm-ss').format(DateTime.now())}${Config.dataExtension}');
      }
      await File(pwdPath).writeAsString(Cipher.encryptString(jsonEncode(data)),
          mode: FileMode.writeOnly);
    } catch (e) {
      rethrow;
    }
  }

  static Future initData() async {
    final baseDirInfo = await getApplicationDocumentsDirectory();
    try {
      List<FileSystemEntity> dataInfo =
          await Directory('${baseDirInfo.path}${Config.dataDir}')
              .list()
              .toList();
      List<FileSystemEntity> backupInfo =
          await Directory('${baseDirInfo.path}${Config.dataDir}')
              .list()
              .toList();
      if (dataInfo.isEmpty || backupInfo.isEmpty) {
        await saveData(Config.dataTemplate);
      } else {
        try {
          await File(
                  '${baseDirInfo.path}${Config.dataDir}/${Config.latestData}')
              .readAsString();
        } on PathNotFoundException {
          saveData(Config.dataTemplate);
        }
      }
    } on PathNotFoundException {
      await Directory('${baseDirInfo.path}${Config.dataDir}')
          .create(recursive: true);
      await Directory('${baseDirInfo.path}${Config.autoBackupDir}')
          .create(recursive: true);
      saveData(Config.dataTemplate);
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<String>> getRestoreInfo() async {
    final baseDirInfo = await getApplicationDocumentsDirectory();
    try {
      List<FileSystemEntity> backupInfo =
          await Directory('${baseDirInfo.path}${Config.autoBackupDir}')
              .list()
              .toList();
      log(backupInfo.toString());
      List<String> tmpList = [
        for (var backup in backupInfo)
          DateConverter.dateForDisplay(
              backup.path.split('/').last.split('.').first)
      ];
      tmpList.sort((a, b) => b.compareTo(a));
      return tmpList;
    } catch (e) {
      rethrow;
    }
  }

  static void restoreData(String targetFileName) async {
    final baseDirInfo = await getApplicationDocumentsDirectory();
    try {
      await File('${baseDirInfo.path}${Config.dataDir}/${Config.latestData}').copy(
          '${baseDirInfo.path}${Config.autoBackupDir}/${DateFormat('yyyy-MM-dd-H-m-s').format(DateTime.now())}${Config.dataExtension}');
      File('${baseDirInfo.path}${Config.autoBackupDir}/$targetFileName${Config.dataExtension}')
          .copy('${baseDirInfo.path}${Config.dataDir}/${Config.latestData}');
    } catch (e) {
      rethrow;
    }
  }
}
