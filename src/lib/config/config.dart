import 'package:intl/intl.dart';

class Config {
  static const String dataDir = '/data';
  static const String autoBackupDir = '/backup';
  static const String loggingDir = '/logs';
  static const String dataExtension = '.json';
  static const String latestData = 'latest.json';
  static String exportFileName =
      '${DateFormat('yyyy-MM-dd-HH-mm-ss').format(DateTime.now())}_password.json';
  static const Map<String, dynamic> dataTemplate = {
    'passwords': {},
    'settings': {'auto_backup': false}
  };
}
