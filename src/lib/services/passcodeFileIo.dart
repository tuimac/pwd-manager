import 'dart:io';
import 'dart:math';
import 'package:src/services/logFileIo.dart';
import 'package:src/config/config.dart';

// File read/write service classs
class PasscodeIO {
  // Read the logs file
  static Future<String> get getPasscode async {
    try {
      return await File(await Config.getPasscodePath).readAsString();
    } catch (e) {
      LogFileIO.logging(e.toString());
      rethrow;
    }
  }

  // Write the log messages
  static Future registerPasscode() async {
    try {
      const charset =
          '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
      final random = Random.secure();
      final key =
          List.generate(32, (_) => charset[random.nextInt(charset.length)])
              .join();
      await File(await Config.getPasscodePath)
          .writeAsString(key, mode: FileMode.writeOnly);
    } catch (e) {
      LogFileIO.logging(e.toString());
      rethrow;
    }
  }
}
