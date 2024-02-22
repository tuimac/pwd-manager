import 'package:encrypt/encrypt.dart';
import 'package:src/services/logFileIo.dart';
import 'package:src/services/passcodeFileIo.dart';

class Cipher {
  static Future<String> encryptData(String data, {String password = ''}) async {
    try {
      return await PasscodeIO.getPasscode.then((passCode) {
        if (password == '') {
          final encrypter =
              Encrypter(AES(Key.fromUtf8(passCode), mode: AESMode.ecb));
          return encrypter.encrypt(data).base64;
        } else {
          final encrypter =
              Encrypter(AES(Key.fromUtf8(password), mode: AESMode.ecb));
          return encrypter.encrypt(data).base64;
        }
      });
    } catch (e) {
      LogFileIO.logging(e.toString());
      rethrow;
    }
  }

  static Future<String> decryptData(String data, {String password = ''}) async {
    try {
      return await PasscodeIO.getPasscode.then((passCode) {
        if (password == '') {
          final encrypter =
              Encrypter(AES(Key.fromUtf8(passCode), mode: AESMode.ecb));
          return encrypter.decrypt(Encrypted.fromBase64(data));
        } else {
          final encrypter =
              Encrypter(AES(Key.fromUtf8(password), mode: AESMode.ecb));
          return encrypter.decrypt(Encrypted.fromBase64(data));
        }
      });
    } catch (e) {
      LogFileIO.logging(e.toString());
      rethrow;
    }
  }
}
