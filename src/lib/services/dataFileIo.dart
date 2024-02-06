import 'dart:convert';
import 'dart:io';
import 'package:src/services/logFileIo.dart';
import 'package:src/utils/validation.dart';
import 'package:src/utils/cipher.dart';
import 'package:src/config/config.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:external_path/external_path.dart';
import 'package:permission_handler/permission_handler.dart';

// File read/write service classs
class DataFileIO {
  // Read the data file
  static Future<Map<String, dynamic>> getData() async {
    try {
      return jsonDecode(await File(await Config.getDataPath).readAsString());
    } on PathNotFoundException {
      return Validation.checkDataContent(Config.dataTemplate);
    } catch (e) {
      LogFileIO.logging(e.toString());
      rethrow;
    }
  }

  // Write the data file
  static Future saveData(Map<String, dynamic> data,
      {String mode = 'default'}) async {
    try {
      if (mode == 'default') {
        if (data['settings']['auto_backup']) {
          await File(await Config.getDataPath).copy(
              '${await Config.getBackupDir}${DateFormat('yyyy-MM-dd-HH-mm-ss').format(DateTime.now())}${Config.dataExtension}');
        }
      }
      String passCode = data['pass_code'];
      data.remove('pass_code');
      await File(await Config.getDataPath).writeAsString(
          jsonEncode(Cipher.encryptData(data, passCode)),
          mode: FileMode.writeOnly);
    } catch (e) {
      LogFileIO.logging(e.toString());
      rethrow;
    }
  }

  // Read Restore file names in the autobackup folder
  static Future<List<Map<String, dynamic>>> getRestoreInfo() async {
    try {
      List<FileSystemEntity> backupFileList =
          await Directory(await Config.getBackupDir).list().toList();
      List<Map<String, dynamic>> backupInfo = [];
      for (var backupName in backupFileList) {
        backupInfo.add({
          'name': backupName.path.split('/').last.split('.').first,
          'size': File(backupName.path).lengthSync()
        });
      }
      return backupInfo;
    } catch (e) {
      LogFileIO.logging(e.toString());
      rethrow;
    }
  }

  // Restore data file from the data in autobackup folder
  static void restoreData(String targetFileName) async {
    try {
      await File(await Config.getDataPath).copy(
          '${await Config.getBackupDir}${DateFormat('yyyy-MM-dd-HH-mm-ss').format(DateTime.now())}${Config.dataExtension}');
      File('${await Config.getBackupDir}/$targetFileName${Config.dataExtension}')
          .copy(await Config.getBackupDir);
    } catch (e) {
      LogFileIO.logging(e.toString());
      rethrow;
    }
  }

  // Delete autobackup file
  static void deleteRestoreData(String restoreFileName) async {
    try {
      await File(
              '${await Config.getBackupDir}/$restoreFileName${Config.dataExtension}')
          .delete();
    } catch (e) {
      LogFileIO.logging(e.toString());
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
      LogFileIO.logging(e.toString());
      rethrow;
    }
  }
}