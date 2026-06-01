import 'package:src/services/config_file_io.dart';
import 'dart:math';

class GeneratePassword {
  static Future<String> genPassword() async {
    Map<String, dynamic> passwordRules = await ConfigFileIO.getConfig()
        .then((config) => config['password_rule']);
    const String lowerCases = 'abcdefghijklmnopqrstuvwxyz';
    const String upperCases = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String numbers = '0123456789';
    const String specialChars = r'!@#$%^&*()_+-=[]{}|;:,.<>?';
    List<String> passwordList = [];
    String compositeSeedList = '';
    final random = Random.secure();

    // Function to pick random character from a string
    String pickRandomChar(String chars) {
      return chars[random.nextInt(chars.length)];
    }

    // Lower case random pickup
    if (passwordRules["lowercase"]) {
      passwordList.add(pickRandomChar(lowerCases));
      compositeSeedList += lowerCases;
    }
    // Upper case random pickup
    if (passwordRules["uppercase"]) {
      passwordList.add(pickRandomChar(upperCases));
      compositeSeedList += upperCases;
    }
    // Number random pickup
    if (passwordRules["numbers"]) {
      passwordList.add(pickRandomChar(numbers));
      compositeSeedList += numbers;
    }
    // Special character random pickup
    if (passwordRules["special_chars"]) {
      passwordList.add(pickRandomChar(specialChars));
      compositeSeedList += specialChars;
    }
    int passwordListLength = passwordList.length;
    for (int i = 0; i < passwordRules["length"] - passwordListLength; i++) {
      passwordList.add(
        compositeSeedList[random.nextInt(compositeSeedList.length)],
      );
    }
    passwordList.shuffle();
    return passwordList.join();
  }
}
