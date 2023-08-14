import 'package:minio_new/minio.dart';
import 'dart:typed_data';
import 'dart:convert';

class S3Service {
  static Future<Map<String, dynamic>> getPasswordFile() async {
    final minio = Minio(
      endPoint: 's3.ap-northeast-3.amazonaws.com',
      accessKey: '',
      secretKey: '',
      region: 'ap-northeast-3',
      useSSL: true,
    );
    final stream = await minio.getObject('tuimac-redmine', 'password.json');
    List<int> memory = [];
    await for (var value in stream) {
      memory.addAll(value);
    }
    return json.decode(String.fromCharCodes(Uint8List.fromList(memory)))
        as Map<String, dynamic>;
  }
}
