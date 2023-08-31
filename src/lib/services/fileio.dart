import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:src/utils/cipher.dart';

class FileIO {
  static Future<Map<String, dynamic>> get getData async {
    try {
      final baseDirInfo = await getApplicationDocumentsDirectory();
      final pwdPath = '${baseDirInfo.path}/latest.pwdm';
      log(pwdPath);
      return jsonDecode(
          Cipher.decryptString(await File(pwdPath).readAsString()));
    } catch (e) {
      return {
        'passwords': {},
        'setting': {'auto_backup': false}
      };
    }
  }

  static void saveData(data) async {
    final baseDirInfo = await getApplicationDocumentsDirectory();
    final pwdPath = '${baseDirInfo.path}/latest.pwdm';
    if (data['setting']['auto_backup']) {
      final newPath =
          '${baseDirInfo.path}/${DateFormat('yyyy-MM-dd-H-m-s').format(DateTime.now())}.pwdm';
      await File(pwdPath).copy(newPath);
    }
    await File(pwdPath).writeAsString(Cipher.encryptString(jsonEncode(data)),
        mode: FileMode.writeOnly);
  }
}
