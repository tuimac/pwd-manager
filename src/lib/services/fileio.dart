import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileIO {
  static Future<Map<String, dynamic>> get getPassword async {
    try {
      final baseDirInfo = await getApplicationDocumentsDirectory();
      final pwdPath = '${baseDirInfo.path}/password.json';
      return jsonDecode(await File(pwdPath).readAsString());
    } catch (e) {
      return {'passwords': []};
    }
  }

  static void savePassword(data) async {
    final baseDirInfo = await getApplicationDocumentsDirectory();
    final pwdPath = '${baseDirInfo.path}/password.json';
    await File(pwdPath)
        .writeAsString(jsonEncode(data), mode: FileMode.writeOnly);
  }
}
