import 'package:encrypt/encrypt.dart';

class Cipher {
  static String encryptString(String plainText) {
    final key = Key.fromUtf8('testtesttesttesttesttesttesttest');
    final iv = IV.fromLength(8);
    final encrypter = Encrypter(Salsa20(key));
    return encrypter.encrypt(plainText, iv: iv).base64;
  }

  static String decryptString(String encryptedText) {
    final key = Key.fromUtf8('testtesttesttesttesttesttesttest');
    final iv = IV.fromLength(8);
    final encrypter = Encrypter(Salsa20(key));
    return encrypter.decrypt(Encrypted.fromBase64(encryptedText), iv: iv);
  }
}
