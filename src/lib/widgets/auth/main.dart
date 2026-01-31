<<<<<<< HEAD
// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:developer';
=======
>>>>>>> ad876582df9d66bfeda6f37c78853e6862b2b3d5
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:src/services/configFileIO.dart';
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
<<<<<<< HEAD
        GoRouter.of(context).go('/listpwd', extra: await FileIO.getData());
      } else {
        setState(() {
          authType = 'login';
        });
=======
        GoRouter.of(context).go('/listpwd');
>>>>>>> ad876582df9d66bfeda6f37c78853e6862b2b3d5
      }
    } on PlatformException {
      LogFileIO.logging('Bio authentication PlatformException');
      GoRouter.of(context).go('/listpwd');
    } catch (e) {
      LogFileIO.logging(e.toString());
      return;
    }
  }

<<<<<<< HEAD
  void inputNumber(int number) {
    if (typedNumbers.length < 8) {
      setState(() {
        typedNumbers += number.toString();
        typedDots.add(Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Icon(
              Icons.circle,
              color: Colors.white,
              size: dotsSize,
            )));
        if (typedNumbers.isNotEmpty) {
          dotsSizePadding = 0;
        }
      });
    }
  }

  void deleteNumber() {
    setState(() {
      if (typedNumbers.isNotEmpty) {
        typedNumbers = typedNumbers.substring(0, typedNumbers.length - 1);
        typedDots.removeAt(typedDots.length - 1);
        if (typedNumbers.isEmpty) {
          dotsSizePadding = dotsSize;
        }
      }
    });
  }

  void tryLogin() async {
    if (typedNumbers.length >= 4 && typedNumbers.length <= 8) {
      if (authType == 'signin') {
        setState(() {
          signinNumbers = typedNumbers;
          authType = 'confirm';
          headLine = 'Retype passcode';
          typedNumbers = '';
          typedDots = [];
          dotsSizePadding = dotsSize;
        });
      } else if (authType == 'confirm') {
        if (signinNumbers == typedNumbers) {
          await FileIO.registerPasscode(signinNumbers);
          await FileIO.saveData(data);
          GoRouter.of(context).go('/listpwd', extra: await FileIO.getData());
        } else {
          setState(() {
            signinNumbers = '';
            typedNumbers = '';
            typedDots = [];
            authType = 'signin';
            headLine = 'Register passcode.';
            dotsSizePadding = dotsSize;
          });
        }
      } else if (authType == 'login') {
        if (await FileIO.getPasscode() == typedNumbers) {
          GoRouter.of(context).go('/listpwd', extra: data);
        } else {
          setState(() {
            signinNumbers = '';
            typedNumbers = '';
            typedDots = [];
            authType = 'login';
            headLine = 'Invalid passcode.';
            dotsSizePadding = dotsSize;
          });
        }
      }
    }
  }

=======
>>>>>>> ad876582df9d66bfeda6f37c78853e6862b2b3d5
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
