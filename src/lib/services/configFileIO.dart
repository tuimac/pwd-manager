import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:src/utils/validation.dart';
import 'package:src/services/logFileIo.dart';
import 'package:src/config/config.dart';

// File read/write service classs
class ConfigFileIO {
  // Read the data file
  static Future<Map<String, dynamic>> getConfig() async {
    try {
      return Validation.checkConfigContent(
          jsonDecode(await File(await Config.getConfigPath).readAsString()));
    } on PathNotFoundException {
      return Validation.checkConfigContent(Config.configTemplate);
    } catch (e) {
      LogFileIO.logging(e.toString());
      rethrow;
    }
  }

  // Write the data file
  static Future saveConfig(Map<String, dynamic> config) async {
    try {
      log(config.toString());
      await File(await Config.getConfigPath)
          .writeAsString(jsonEncode(config), mode: FileMode.writeOnly);
    } catch (e) {
      LogFileIO.logging(e.toString());
      rethrow;
    }
  }
}
