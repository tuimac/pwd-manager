import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:developer';
import 'package:cross_file/cross_file.dart';

class FIleIO {
  static Future<Map<String, dynamic>> get getPassword async {
    final directory = await getApplicationDocumentsDirectory();
    log(directory.path);
    return {};
  }
}
