import 'dart:math';

class UnitConvert {
  static String fileSizeConvert(int fileSize) {
    if (fileSize < 1024) {
      return '${fileSize.toString()} B';
    } else if (1024 <= fileSize && fileSize < pow(1024, 2)) {
      return '${(fileSize / 1024).round().toString()} KB';
    } else if (pow(1024, 2) <= fileSize && fileSize < pow(1024, 3)) {
      return '${(fileSize / pow(1024, 2)).round().toString()} MB';
    } else if (pow(1024, 3) <= fileSize && fileSize < pow(1024, 4)) {
      return '${(fileSize / pow(1024, 4)).round().toString()} GB';
    } else {
      return fileSize.toString();
    }
  }
}
