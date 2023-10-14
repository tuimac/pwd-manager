import 'package:encrypt/encrypt.dart';
import 'dart:developer';

class Cipher {
  static String encryptString(String plainText, String keyPhrase) {
    try {
      while (keyPhrase.length < 16) {
        keyPhrase += keyPhrase;
      }
      log(keyPhrase);
      final key = Key.fromUtf8(keyPhrase);
      final iv = IV.fromLength(8);
      final encrypter = Encrypter(Salsa20(key));
      return encrypter.encrypt(plainText, iv: iv).base64;
    } catch (e) {
      throw Exception(e);
    }
  }

  static String decryptString(String encryptedText, String keyPhrase) {
    try {
      while (keyPhrase.length < 16) {
        keyPhrase += keyPhrase;
      }
      final key = Key.fromUtf8(keyPhrase);
      final iv = IV.fromLength(8);
      final encrypter = Encrypter(Salsa20(key));
      return encrypter.decrypt(Encrypted.fromBase64(encryptedText), iv: iv);
    } catch (e) {
      throw Exception(e);
    }
  }
}
