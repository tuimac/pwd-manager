import 'dart:math';
import 'dart:developer' as log;

class PasswordGen {
  static String _genRandomChar(Map<String, dynamic> passwordRule, String rule) {
    log.log(rule);
    if (rule == 'min_lower_char_length' &&
        passwordRule['min_rules'][rule] > 0) {
      return String.fromCharCode(Random().nextInt(122 - 97) + 97);
    } else if (rule == 'min_upper_char_length' &&
        passwordRule['min_rules'][rule] > 0) {
      return String.fromCharCode(Random().nextInt(90 - 65) + 65);
    } else if (rule == 'min_num_length' &&
        passwordRule['min_rules'][rule] > 0) {
      return Random().nextInt(9).toString();
    } else if (rule == 'min_special_length' &&
        passwordRule['min_rules'][rule] > 0) {
      return String.fromCharCode(Random().nextInt(47 - 33) + 33);
    } else {
      return '';
    }
  }

  static String genPassword(Map<String, dynamic> passwordRule) {
    List<String> password = List<String>.filled(passwordRule['length'], '');
    while (password.contains('')) {
      String tmpChar = '';
      for (String rule in passwordRule['min_rules'].keys) {
        tmpChar = _genRandomChar(passwordRule, rule);
        if (tmpChar.isEmpty) {
          List<String> pwdMinRules = passwordRule['min_rules'].keys.toList();
          tmpChar = _genRandomChar(
              passwordRule, pwdMinRules[Random().nextInt(passwordRule.length)]);
        } else {
          passwordRule['min_rules'][rule]--;
        }
      }
      log.log(tmpChar);
      while (true) {
        if (password[Random().nextInt(passwordRule['length'])] == '') {
          password[Random().nextInt(passwordRule['length'])] = tmpChar;
          break;
        }
      }
    }
    return password.join();
  }
}
