import 'package:encrypt/encrypt.dart';
import 'dart:convert';
import 'dart:developer';

class Cipher {
  static String encryptString(String plainText, String keyPhrase) {
    try {
      keyPhrase = base64.encode(utf8.encode(keyPhrase));
      String keyPhraseforEncrypt = '';
      for (var i = 0; i < keyPhrase.length; i++) {
        keyPhraseforEncrypt += keyPhrase.codeUnitAt(i).toString();
      }
      final key = Key.fromUtf8(keyPhraseforEncrypt);
      final iv = IV.fromLength(8);
      final encrypter = Encrypter(Salsa20(key));
      return encrypter.encrypt(plainText, iv: iv).base64;
    } catch (e) {
      log('[EncryptString] ${e.toString()}');
      throw Exception(e);
    }
  }

  static String decryptString(String encryptedText, String keyPhrase) {
    try {
      keyPhrase = base64.encode(utf8.encode(keyPhrase));
      String keyPhraseforDecrypt = '';
      for (var i = 0; i < keyPhrase.length; i++) {
        keyPhraseforDecrypt += keyPhrase.codeUnitAt(i).toString();
      }
      final key = Key.fromUtf8(keyPhraseforDecrypt);
      final iv = IV.fromLength(8);
      final encrypter = Encrypter(Salsa20(key));
      return encrypter.decrypt(Encrypted.fromBase64(encryptedText), iv: iv);
    } catch (e) {
      log('[DecryptString] ${e.toString()}');
      throw Exception(e);
    }
  }

  static Map<String, dynamic> encryptData(
      Map<String, dynamic> data, String keyPhrase) {
    try {
      data['passwords'] =
          encryptString(jsonEncode(data['passwords']), keyPhrase);
      return data;
    } catch (e) {
      throw Exception('[EncryptData] ${e.toString()}');
    }
  }

  static Map<String, dynamic> decryptData(
      Map<String, dynamic> data, String keyPhrase) {
    try {
      data['passwords'] =
          jsonDecode(decryptString(data['passwords'], keyPhrase));
      return data;
    } catch (e) {
      throw Exception('[DecryptData] ${e.toString()}');
    }
  }
}
