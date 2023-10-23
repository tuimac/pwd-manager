import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'dart:developer' as log;
import 'package:path/path.dart';
import 'package:src/utils/checkData.dart';
import 'package:src/utils/cipher.dart';
import 'package:src/config/config.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:external_path/external_path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:src/widgets/logging/main.dart';

// File read/write service classs
class FileIO {
  static Future<String> get baseDirInfo async {
    if (Platform.isAndroid) {
      return (await getApplicationDocumentsDirectory()).path;
    } else {
      return (await getLibraryDirectory()).path;
    }
  }

  static Future<bool> isExist(String dataType) async {
    switch (dataType) {
      case 'datadir':
        return await File('${await FileIO.baseDirInfo}/${Config.dataDir}')
            .exists();
      case 'datafile':
        return await File(
                '${await FileIO.baseDirInfo}/${Config.dataDir}/${Config.latestData}')
            .exists();
      case 'backup':
        return await File('${await FileIO.baseDirInfo}/${Config.autoBackupDir}')
            .exists();
      case 'log':
        return await File('${await FileIO.baseDirInfo}/${Config.loggingDir}')
            .exists();
      default:
        throw Exception('Invalid data type.');
    }
  }

  // Read the data file
  static Future<Map<String, dynamic>> getData() async {
    try {
      return jsonDecode(await File(
              '${await FileIO.baseDirInfo}/${Config.dataDir}/${Config.latestData}')
          .readAsString());
    } on PathNotFoundException {
      CheckData.checkDataPath();
      return CheckData.checkDataContent(Config.dataTemplate);
    } catch (e) {
      rethrow;
    }
  }

  // Write the data file
  static Future saveData(Map<String, dynamic> data,
      {String mode = 'default'}) async {
    final pwdPath =
        '${await FileIO.baseDirInfo}/${Config.dataDir}/${Config.latestData}';
    try {
      if (mode == 'default') {
        if (data['settings']['auto_backup']) {
          await File(pwdPath).copy(
              '${await FileIO.baseDirInfo}/${Config.autoBackupDir}/${DateFormat('yyyy-MM-dd-HH-mm-ss').format(DateTime.now())}${Config.dataExtension}');
        }
      }
      String passCode = data['pass_code'];
      data.remove('pass_code');
      await File(pwdPath).writeAsString(
          jsonEncode(Cipher.encryptData(data, passCode)),
          mode: FileMode.writeOnly);
      data['pass_code'] = passCode;
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

  static Future<dynamic> getPasscode() async {
    try {
      final directory =
          Directory('${await FileIO.baseDirInfo}/${Config.dataDir}');
      final List<FileSystemEntity> filenameList =
          await directory.list().toList();
      String passcodeFileName = '';
      for (final filename in filenameList) {
        if (RegExp(r'.*' + Config.passcodeFileExtension + r'$')
            .hasMatch(filename.path)) {
          passcodeFileName = filename.path;
          break;
        }
      }
      log.log(await File(passcodeFileName).readAsString());
      return Cipher.decryptString(await File(passcodeFileName).readAsString(),
          basename(passcodeFileName));
    } on PathNotFoundException catch (e) {
      log.log(e.toString());
      CheckData.checkDataPath();
    } catch (e) {
      log.log(e.toString());
      rethrow;
    }
  }

  static Future<dynamic> registerPasscode(String passCode) async {
    try {
      final String passForPasscode = String.fromCharCodes(
          List.generate(32, (index) => Random().nextInt(26) + 65));
      await File(
              '${await FileIO.baseDirInfo}/${Config.dataDir}/$passForPasscode${Config.passcodeFileExtension}')
          .writeAsString(
              Cipher.encryptString(
                  passCode, '$passForPasscode${Config.passcodeFileExtension}'),
              mode: FileMode.writeOnlyAppend);
    } on PathNotFoundException {
      CheckData.checkDataPath();
    } catch (e) {
      rethrow;
    }
  }

  void logging(String messages) async {
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
