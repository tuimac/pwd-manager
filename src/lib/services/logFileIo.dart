import 'dart:io';
import 'package:src/config/config.dart';
import 'dart:developer';

// File read/write service classs
class LogFileIO {
  // Read the logs file
  static Future<String> getLog() async {
    try {
      return await File(await Config.getLogPath).readAsString();
    } catch (e) {
      LogFileIO.logging(e.toString());
      rethrow;
    }
  }

  // Write the log messages
  static Future logging(String message) async {
    try {
      log(message);
      await File(await Config.getLogPath)
          .writeAsString(message, mode: FileMode.writeOnly);
    } catch (e) {
      LogFileIO.logging(e.toString());
      rethrow;
    }
  }
}
