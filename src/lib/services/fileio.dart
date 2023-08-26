import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:developer';

class FIleIO {
  static Future<Map<String, dynamic>> get getPassword async {
    final directory = await getApplicationDocumentsDirectory();
    log(directory.path);
    return {};
  }
}
