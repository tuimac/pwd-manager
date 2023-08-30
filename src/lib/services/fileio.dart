import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:src/utils/cipher.dart';

class FileIO {
  static Future<Map<String, dynamic>> get getPassword async {
    try {
      final baseDirInfo = await getApplicationDocumentsDirectory();
      final pwdPath = '${baseDirInfo.path}/latest.pwdm';
      return jsonDecode(
          Cipher.decryptString(await File(pwdPath).readAsString()));
    } catch (e) {
      return {'passwords': []};
    }
  }

  static void savePassword(data) async {
    final baseDirInfo = await getApplicationDocumentsDirectory();
    final pwdPath = '${baseDirInfo.path}/latest.pwdm';
    await File(pwdPath).writeAsString(Cipher.encryptString(jsonEncode(data)),
        mode: FileMode.writeOnly);
  }
}
