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
  late Map<String, dynamic> config = {};

  @override
  void initState() {
    super.initState();
    Validation.checkFilePath().then((checkFileResult) {
      ConfigFileIO.getConfig().then((configResult) {
        setState(() {
          config = configResult;
        });
        bioAuth();
      });
    });
  }

  Future<void> bioAuth() async {
    try {
      if (config['bio_auth'] == true) {
        final bool authState = await auth.authenticate(
          localizedReason: 'Authenticate to show password list',
          options: const AuthenticationOptions(
            stickyAuth: false,
            biometricOnly: true,
          ),
          authMessages: const [
            AndroidAuthMessages(
              cancelButton: 'Cancel',
            ),
            IOSAuthMessages(
              cancelButton: 'Cancel',
            ),
          ],
        );

        if (!mounted) return;

        if (authState) {
          GoRouter.of(context).go('/listpwd');
        } else {
          setState(() {
            authActionStatus = false;
          });
          GoRouter.of(context).go('/');
        }
      } else {
        if (!mounted) return;
        GoRouter.of(context).go('/listpwd');
      }
    } on PlatformException catch (e) {
      LogFileIO.logging(
          'Bio authentication PlatformException: ${e.code} ${e.message}');

      if (!mounted) return;
      GoRouter.of(context).go('/');
    } catch (e) {
      LogFileIO.logging(e.toString());

      if (!mounted) return;
      GoRouter.of(context).go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return config.isEmpty
        ? Container()
        : config["bio_auth"]
            ? Scaffold(
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
                                  bioAuth();
                                },
                                child: Text('Login again',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge))))))
            : Container();
  }
}
