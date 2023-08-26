import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FIleIO {
  static Future<Map<String, dynamic>> get getPassword async {
    try {
      final baseDirInfo = await getApplicationDocumentsDirectory();
      final pwdPath = '${baseDirInfo.path}/data/password.json';
      return jsonDecode(await File(pwdPath).readAsString());
    } catch (e) {
      return {'passwords': {}};
    }
  }

  static void createPassword(data) async {
    final baseDirInfo = await getApplicationDocumentsDirectory();
    final pwdPath = '${baseDirInfo.path}/data/password.json';
    File(pwdPath).writeAsString(jsonEncode(data));
  }
}
