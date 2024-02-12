import 'package:encrypt/encrypt.dart';
import 'package:src/services/logFileIo.dart';
import 'package:src/services/passcodeFileIo.dart';

class Cipher {
  static Future<String> encryptData(String data) async {
    try {
      return await PasscodeIO.getPasscode.then((passCode) {
        final key = Key.fromUtf8(passCode);
        final iv = IV.fromLength(8);
        final encrypter = Encrypter(Salsa20(key));
        return encrypter.encrypt(data, iv: iv).base64;
      });
    } catch (e) {
      LogFileIO.logging(e.toString());
      rethrow;
    }
  }

  static Future<String> decryptData(String data) async {
    try {
      return await PasscodeIO.getPasscode.then((passCode) {
        final key = Key.fromUtf8(passCode);
        final iv = IV.fromLength(8);
        final encrypter = Encrypter(Salsa20(key));
        return encrypter.decrypt(Encrypted.fromBase64(data), iv: iv);
      });
    } catch (e) {
      LogFileIO.logging(e.toString());
      rethrow;
    }
  }
}
