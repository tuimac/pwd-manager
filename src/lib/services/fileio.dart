import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:src/utils/cipher.dart';
import 'package:src/config/config.dart';
import 'dart:developer';

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
        final newPath =
            '${baseDirInfo.path}${Config.dataDir}/${DateFormat('yyyy-MM-dd-H-m-s').format(DateTime.now())}${Config.dataExtension}';
        await File(pwdPath).copy(newPath);
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
      List<FileSystemEntity> itemsInfo =
          await Directory('${baseDirInfo.path}${Config.dataDir}')
              .list()
              .toList();
      if (itemsInfo.isEmpty) {
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
      saveData(Config.dataTemplate);
    } catch (e) {
      rethrow;
    }
  }
}
