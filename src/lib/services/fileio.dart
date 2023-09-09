import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:src/utils/sanitizer.dart';
import 'package:src/utils/cipher.dart';
import 'package:src/config/config.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:external_path/external_path.dart';
import 'package:permission_handler/permission_handler.dart';

// File read/write service classs
class FileIO {
  static Future<String> get baseDirInfo async {
    if (Platform.isAndroid) {
      return (await getApplicationDocumentsDirectory()).path;
    } else {
      return (await getLibraryDirectory()).path;
    }
  }

  // Read the data file
  static Future<Map<String, dynamic>> get getData async {
    try {
      return jsonDecode(Cipher.decryptString(await File(
              '${await FileIO.baseDirInfo}/${Config.dataDir}/${Config.latestData}')
          .readAsString()));
    } on PathNotFoundException catch (e) {
      log(e.toString());
      return sanitizeData(Config.dataTemplate);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  // Write the data file
  static Future saveData(Map<String, dynamic> data) async {
    final pwdPath =
        '${await FileIO.baseDirInfo}/${Config.dataDir}/${Config.latestData}';
    try {
      if (data['settings']['auto_backup']) {
        await File(pwdPath).copy(
            '${await FileIO.baseDirInfo}/${Config.autoBackupDir}/${DateFormat('yyyy-MM-dd-HH-mm-ss').format(DateTime.now())}${Config.dataExtension}');
      }
      await File(pwdPath).writeAsString(Cipher.encryptString(jsonEncode(data)),
          mode: FileMode.writeOnly);
    } catch (e) {
      rethrow;
    }
  }

  // Read Restore file names in the autobackup folder
  static Future<List<Map<String, dynamic>>> getRestoreInfo() async {
    try {
      List<FileSystemEntity> backupFileList =
          await Directory('${await FileIO.baseDirInfo}/${Config.autoBackupDir}')
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

  // Restore data file from the data in autobackup folder
  static void restoreData(String targetFileName) async {
    try {
      await File(
              '${await FileIO.baseDirInfo}/${Config.dataDir}/${Config.latestData}')
          .copy(
              '${await FileIO.baseDirInfo}/${Config.autoBackupDir}/${DateFormat('yyyy-MM-dd-HH-mm-ss').format(DateTime.now())}${Config.dataExtension}');
      File('${await FileIO.baseDirInfo}/${Config.autoBackupDir}/$targetFileName${Config.dataExtension}')
          .copy(
              '${await FileIO.baseDirInfo}${Config.dataDir}/${Config.latestData}');
    } catch (e) {
      rethrow;
    }
  }

  // Delete autobackup file
  static void deleteRestoreData(String restoreFileName) async {
    try {
      await File(
              '${await FileIO.baseDirInfo}/${Config.autoBackupDir}/$restoreFileName${Config.dataExtension}')
          .delete();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  static Future<String> exportDataFile(String data) async {
    try {
      await [Permission.storage].request();
      String downloadDirPath = '';
      if (Platform.isAndroid) {
        downloadDirPath = await ExternalPath.getExternalStoragePublicDirectory(
            ExternalPath.DIRECTORY_DOWNLOADS);
      } else if (Platform.isIOS) {
        downloadDirPath = (await getApplicationDocumentsDirectory()).path;
      }
      File('$downloadDirPath/${DateFormat('yyyy-MM-dd-HH-mm-ss').format(DateTime.now())}_password${Config.dataExtension}')
          .writeAsString(data, mode: FileMode.writeOnly);
      return downloadDirPath;
    } catch (e) {
      rethrow;
    }
  }

  void logging(String messages, String mode) async {
    final String logFilePath =
        '${await baseDirInfo}/${Config.loggingDir}/${Config.logFileName}';
    if (await File(logFilePath).exists()) {
      await File(logFilePath)
          .writeAsString(messages, mode: FileMode.writeOnlyAppend);
    } else {
      await File(logFilePath).writeAsString(messages, mode: FileMode.writeOnly);
    }
  }
}
