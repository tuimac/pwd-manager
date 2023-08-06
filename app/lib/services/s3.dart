import 'package:minio_new/minio.dart';
import 'dart:typed_data';
import 'dart:developer' as developer;

class S3Service {
  static Future<String> getPasswordFile() async {
    final minio = Minio(
      endPoint: 's3.ap-northeast-3.amazonaws.com',
      region: 'ap-northeast-3',
      useSSL: true,
    );
    developer.log(minio as String);
    final stream = await minio.getObject('tuimac-redmine', 'password.json');
    List<int> memory = [];
    await for (var value in stream) {
      memory.addAll(value);
    }
    developer.log(String.fromCharCodes(Uint8List.fromList(memory)));
    // ignore: unnecessary_cast
    return String.fromCharCodes(Uint8List.fromList(memory));
  }
}
