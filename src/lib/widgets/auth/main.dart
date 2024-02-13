import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:src/services/configFileIo.dart';
import 'package:src/services/logFileIo.dart';
import 'package:src/utils/validation.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';
import 'package:local_auth/local_auth.dart';

class Authentication extends StatefulWidget {
  const Authentication({Key? key}) : super(key: key);

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  final LocalAuthentication auth = LocalAuthentication();
  int bioAuthFailCount = 0;

  @override
  void initState() {
    super.initState();
    Validation.checkFilePath().then((result) {
      ConfigFileIO.getConfig().then((config) {
        if (config['bio_auth']) {
          bioAuth();
        } else {
          GoRouter.of(context).go('/listpwd');
        }
      });
    });
  }

  Future<void> bioAuth() async {
    try {
      bool authState = await auth.authenticate(
          localizedReason: 'Authenticate to show password list',
          options: const AuthenticationOptions(
            stickyAuth: false,
            biometricOnly: true,
          ),
          authMessages: [
            const AndroidAuthMessages(
              cancelButton: 'PIN auth',
            ),
            const IOSAuthMessages(
              cancelButton: 'PIN auth',
            ),
          ]);
      if (authState) {
        GoRouter.of(context).go('/listpwd');
      }
    } on PlatformException {
      LogFileIO.logging('Bio authentication PlatformException');
      GoRouter.of(context).go('/listpwd');
    } catch (e) {
      LogFileIO.logging(e.toString());
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
