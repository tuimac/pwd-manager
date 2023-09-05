import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:src/utils/cipher.dart';
import 'package:src/config/config.dart';
import 'dart:developer';
import 'package:external_path/external_path.dart';

import 'package:permission_handler/permission_handler.dart';

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
      await Directory('${baseDirInfo.path}${Config.autoBackupDir}')
          .list()
          .toList();
      if (dataInfo.isEmpty) {
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

  static Future<List<Map<String, dynamic>>> getRestoreInfo() async {
    final baseDirInfo = await getApplicationDocumentsDirectory();
    try {
      List<FileSystemEntity> backupFileList =
          await Directory('${baseDirInfo.path}${Config.autoBackupDir}')
              .list()
              .toList();
      List<Map<String, dynamic>> backupInfo = [];
      for (var backupName in backupFileList) {
        backupInfo.add({
          'name': backupName.path.split('/').last.split('.').first,
          'size': File(backupName.path).lengthSync()
        });
      }
      return backupInfo;
    } catch (e) {
      rethrow;
    }
  }

  static void restoreData(String targetFileName) async {
    final baseDirInfo = await getApplicationDocumentsDirectory();
    try {
      await File('${baseDirInfo.path}${Config.dataDir}/${Config.latestData}').copy(
          '${baseDirInfo.path}${Config.autoBackupDir}/${DateFormat('yyyy-MM-dd-HH-mm-ss').format(DateTime.now())}${Config.dataExtension}');
      File('${baseDirInfo.path}${Config.autoBackupDir}/$targetFileName${Config.dataExtension}')
          .copy('${baseDirInfo.path}${Config.dataDir}/${Config.latestData}');
    } catch (e) {
      rethrow;
    }
  }

  static void deleteRestoreData(String restoreFileName) async {
    final baseDirInfo = await getApplicationDocumentsDirectory();
    try {
      await File(
              '${baseDirInfo.path}${Config.autoBackupDir}/$restoreFileName${Config.dataExtension}')
          .delete();
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> exportDataFile(String data) async {
    try {
      await [Permission.storage].request();
      String downloadDirPath = '';
      downloadDirPath = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      log(downloadDirPath);
      File('$downloadDirPath/${Config.exportFileName}')
          .writeAsString(data, mode: FileMode.writeOnly);
    } catch (e) {
      rethrow;
    }
  }
}
