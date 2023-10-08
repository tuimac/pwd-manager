import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:src/services/fileio.dart';
import 'package:src/utils/sanitizer.dart';
import 'package:src/utils/compare.dart';
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
  late Map<String, dynamic> data = {};
  late String headLine = '';
  late String authType = '';
  List<int> typedNumbers = [];
  List<int> signinNumbers = [];
  List<Padding> typedDots = [];
  double buttonSize = 80;
  Map<String, double> numberPadding = {'vertical': 15, 'horizontal': 15};
  double dotsSize = 20;
  double dotsSizePadding = 20;
  double contentsPadding = 50;
  List<List<dynamic>> buttonMap = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
    ['Delete', 0, 'Enter']
  ];
  final LocalAuthentication auth = LocalAuthentication();
  late bool authState;
  bool isBioAuth = false;

  @override
  void initState() {
    FileIO.getData.then((value) {
      sanitizeData(value).then((sanitizedData) {
        setState(() {
          data = sanitizedData;
          if (data['pass_code'].isEmpty) {
            headLine = 'Register passcode.';
            authType = 'signin';
          } else {
            if (data['settings']['bio_auth']) {
              bioAuth();
            } else {
              headLine = 'Type passcode.';
              authType = 'login';
            }
          }
        });
      });
    });
    super.initState();
  }

  Future<void> bioAuth() async {
    try {
      authState = await auth.authenticate(
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
        GoRouter.of(context).go('/listpwd', extra: data);
      }
    } catch (e) {
      log(e.toString());
      return;
    }
  }

  void inputNumber(int number) {
    setState(() {
      typedNumbers.add(number);
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

  void deleteNumber() {
    setState(() {
      if (typedNumbers.isNotEmpty) {
        typedNumbers.removeAt(typedNumbers.length - 1);
        typedDots.removeAt(typedDots.length - 1);
        if (typedNumbers.isEmpty) {
          dotsSizePadding = 20;
        }
      }
    });
  }

  void tryLogin() {
    if (typedNumbers.length > 4 || typedNumbers.length < 8) {
      if (authType == 'signin') {
        setState(() {
          signinNumbers = typedNumbers;
          authType = 'confirm';
          headLine = 'Retype passcode';
          typedNumbers = [];
          typedDots = [];
        });
      } else if (authType == 'confirm') {
        if (Compare.list(signinNumbers, typedNumbers)) {
          GoRouter.of(context).go('/listpwd', extra: data);
        } else {
          signinNumbers = [];
        }
      } else if (authType == 'login') {
        if (Compare.list(data['pass_code'], typedNumbers)) {
          GoRouter.of(context).go('/listpwd', extra: data);
        }
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    Size uiSize = MediaQuery.of(context).size;
    double uiWidth = uiSize.width;

    return Scaffold(
        body: SafeArea(
            child: Center(
                child: data.isEmpty
                    ? LoadingAnimationWidget.discreteCircle(
                        color: Colors.white,
                        size: uiWidth * 0.2,
                      )
                    : isBioAuth
                        ? Container()
                        : Column(children: [
                            Padding(
                                padding: EdgeInsets.only(top: contentsPadding)),
                            Padding(
                                padding: EdgeInsets.only(top: contentsPadding),
                                child: Text(headLine,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 30))),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: contentsPadding + dotsSizePadding)),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: typedDots),
                            Padding(
                                padding: EdgeInsets.only(top: contentsPadding)),
                            Center(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                  for (var rowButtons in buttonMap) ...[
                                    Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                numberPadding['vertical']!),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              for (var buttonContent
                                                  in rowButtons) ...[
                                                Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal:
                                                            numberPadding[
                                                                'horizontal']!),
                                                    child: SizedBox(
                                                        height: buttonSize,
                                                        width: buttonSize,
                                                        child: (() {
                                                          if (buttonContent ==
                                                              'Delete') {
                                                            return IconButton(
                                                                onPressed: () {
                                                                  deleteNumber();
                                                                },
                                                                icon: Icon(
                                                                    Icons
                                                                        .backspace,
                                                                    color: Colors
                                                                        .white,
                                                                    size:
                                                                        buttonSize /
                                                                            2));
                                                          } else if (buttonContent ==
                                                              'Enter') {
                                                            return IconButton(
                                                                onPressed: () {
                                                                  tryLogin();
                                                                },
                                                                icon: Icon(
                                                                  Icons.done,
                                                                  color: Colors
                                                                      .white,
                                                                  size:
                                                                      buttonSize /
                                                                          2,
                                                                ));
                                                          } else {
                                                            return ElevatedButton(
                                                                onPressed: () {
                                                                  inputNumber(
                                                                      buttonContent);
                                                                },
                                                                style: ElevatedButton.styleFrom(
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                50)),
                                                                    backgroundColor:
                                                                        const Color.fromARGB(
                                                                            255,
                                                                            119,
                                                                            168,
                                                                            208)),
                                                                child: Text(
                                                                    buttonContent
                                                                        .toString(),
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            40)));
                                                          }
                                                        })()))
                                              ]
                                            ]))
                                  ]
                                ]))
                          ]))));
  }
}
