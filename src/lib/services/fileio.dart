import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:src/utils/cipher.dart';
import 'package:src/config/config.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:external_path/external_path.dart';
import 'package:permission_handler/permission_handler.dart';

// File read/write service classs
class FileIO {
  static Future<String> get _baseDirInfo async {
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
              '${await FileIO._baseDirInfo}${Config.dataDir}/${Config.latestData}')
          .readAsString()));
    } catch (e) {
      log('ReadFile: ' + e.toString());
      initData();
      return Config.dataTemplate;
    }
  }

  // Write the data file
  static Future saveData(data) async {
    final pwdPath =
        '${await FileIO._baseDirInfo}${Config.dataDir}/${Config.latestData}';
    try {
      if (data['settings']['auto_backup']) {
        await File(pwdPath).copy(
            '${await FileIO._baseDirInfo}${Config.autoBackupDir}/${DateFormat('yyyy-MM-dd-HH-mm-ss').format(DateTime.now())}${Config.dataExtension}');
      }
      await File(pwdPath).writeAsString(Cipher.encryptString(jsonEncode(data)),
          mode: FileMode.writeOnly);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  // Create the folder and data file as initialization
  static Future initData() async {
    // If there is no data in data directory.
    try {
      List<FileSystemEntity> dataInfo =
          await Directory('${await FileIO._baseDirInfo}${Config.dataDir}')
              .list()
              .toList();
      log('InitData');
      log(dataInfo.toString());
      if (dataInfo.isEmpty) {
        await saveData(Config.dataTemplate);
      } else {
        try {
          await File(
                  '${await FileIO._baseDirInfo}${Config.dataDir}/${Config.latestData}')
              .readAsString();
        } catch (e) {
          saveData(Config.dataTemplate);
        }
      }
    } catch (e) {
      await Directory('${await FileIO._baseDirInfo}${Config.dataDir}')
          .create(recursive: true);
    }
    // If there is no back up directory.
    try {
      await Directory('${await FileIO._baseDirInfo}${Config.autoBackupDir}')
          .list()
          .toList();
    } catch (e) {
      await Directory('${await FileIO._baseDirInfo}${Config.autoBackupDir}')
          .create(recursive: true);
    }
    // If there is no log directory.
    try {
      await Directory('${await FileIO._baseDirInfo}${Config.loggingDir}')
          .list()
          .toList();
    } catch (e) {
      await Directory('${await FileIO._baseDirInfo}${Config.loggingDir}')
          .create(recursive: true);
    }
  }

  // Read Restore file names in the autobackup folder
  static Future<List<Map<String, dynamic>>> getRestoreInfo() async {
    try {
      List<FileSystemEntity> backupFileList =
          await Directory('${await FileIO._baseDirInfo}${Config.autoBackupDir}')
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
              '${await FileIO._baseDirInfo}${Config.dataDir}/${Config.latestData}')
          .copy(
              '${await FileIO._baseDirInfo}${Config.autoBackupDir}/${DateFormat('yyyy-MM-dd-HH-mm-ss').format(DateTime.now())}${Config.dataExtension}');
      File('${await FileIO._baseDirInfo}${Config.autoBackupDir}/$targetFileName${Config.dataExtension}')
          .copy(
              '${await FileIO._baseDirInfo}${Config.dataDir}/${Config.latestData}');
    } catch (e) {
      rethrow;
    }
  }

  // Delete autobackup file
  static void deleteRestoreData(String restoreFileName) async {
    try {
      await File(
              '${await FileIO._baseDirInfo}${Config.autoBackupDir}/$restoreFileName${Config.dataExtension}')
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
}
