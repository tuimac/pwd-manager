import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:src/services/config_file_io.dart';
import 'package:src/services/log_file_io.dart';
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
  bool authActionStatus = false;

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
      setState(() {
        authActionStatus = true;
      });
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
      } else {
        setState(() {
          authActionStatus = false;
        });
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
    return Scaffold(
        body: Center(
            child: AnimatedOpacity(
                opacity: authActionStatus ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 5000),
                curve: Curves.easeInOut,
                child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        gradient: const LinearGradient(colors: [
                          Colors.blue,
                          Colors.white,
                        ])),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shape: const CircleBorder(),
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () {
                          Validation.checkFilePath().then((result) {
                            ConfigFileIO.getConfig().then((config) {
                              if (config['bio_auth']) {
                                bioAuth();
                              } else {
                                GoRouter.of(context).go('/listpwd');
                              }
                            });
                          });
                        },
                        child: Text('Login again',
                            style: Theme.of(context).textTheme.bodyLarge))))));
  }
}
