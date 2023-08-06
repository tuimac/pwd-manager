import 'package:minio_new/minio.dart';
import 'dart:typed_data';

class S3Service {
  static Future<String> getPasswordFile() async {
    final minio = Minio(
      endPoint: 's3.ap-northeast-3.amazonaws.com',
      region: 'ap-northeast-3',
      useSSL: true,
    );
    final stream = await minio.getObject('tuimac-redmine', 'password.json');
    List<int> memory = [];
    await for (var value in stream) {
      memory.addAll(value);
    }
    return String.fromCharCodes(Uint8List.fromList(memory));
  }
}
