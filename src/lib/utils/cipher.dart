import 'package:encrypt/encrypt.dart';
import 'package:src/services/logFileIo.dart';
import 'package:src/services/passcodeFileIo.dart';

class Cipher {
  static Future<String> encryptData(String data) async {
    try {
      return await PasscodeIO.getPasscode.then((passCode) {
        final encrypter =
            Encrypter(AES(Key.fromUtf8(passCode), mode: AESMode.ecb));
        return encrypter.encrypt(data).base64;
      });
    } catch (e) {
      LogFileIO.logging(e.toString());
      rethrow;
    }
  }

  static Future<String> decryptData(String data) async {
    try {
      return await PasscodeIO.getPasscode.then((passCode) {
        final encrypter =
            Encrypter(AES(Key.fromUtf8(passCode), mode: AESMode.ecb));
        return encrypter.decrypt(Encrypted.fromBase64(data));
      });
    } catch (e) {
      LogFileIO.logging(e.toString());
      rethrow;
    }
  }
}
