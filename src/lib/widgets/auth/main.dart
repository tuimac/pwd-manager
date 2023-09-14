// ignore: file_names
import 'package:flutter/material.dart';
import 'package:src/widgets/auth/numberButton.dart';
import 'package:src/services/fileio.dart';
import 'package:src/utils/sanitizer.dart';
import 'package:src/utils/compare.dart';
import 'package:go_router/go_router.dart';
import 'dart:developer';

class Authentication extends StatefulWidget {
  const Authentication({Key? key}) : super(key: key);

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  late Map<String, dynamic> data;
  late String authType;
  String headLine = '';
  List<int> typedNumbers = [];
  List<int> signinNumbers = [];
  List<Padding> typedDots = [];
  double buttonSize = 70;
  Map<String, double> numberPadding = {'vertical': 15, 'horizontal': 15};
  double dotsSize = 20;
  double dotsSizePadding = 20;
  double contentsPadding = 50;

  @override
  void initState() {
    FileIO.getData.then((value) {
      sanitizeData(value).then((sanitizedData) {
        setState(() {
          data = sanitizedData;
          if (data['pass_code'].isEmpty) {
            authType = 'signin';
            headLine = 'Register passcode';
          } else {
            authType = 'login';
            headLine = 'Type passcode';
          }
        });
      });
    });
    super.initState();
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

  void tryLogin() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
                child: Column(children: [
      Padding(padding: EdgeInsets.only(top: contentsPadding + dotsSizePadding)),
      Padding(
          padding: EdgeInsets.only(top: contentsPadding),
          child: Text(headLine,
              style: const TextStyle(color: Colors.white, fontSize: 30))),
      Padding(padding: EdgeInsets.only(top: contentsPadding + dotsSizePadding)),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: typedDots),
      Padding(padding: EdgeInsets.only(top: contentsPadding)),
      Center(
          child: Padding(
              padding:
                  EdgeInsets.symmetric(vertical: numberPadding['vertical']!),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: numberPadding['horizontal']!),
                          child: NumberButton(
                              number: 1,
                              inputNumber: inputNumber,
                              buttonSize: buttonSize)),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: numberPadding['horizontal']!),
                          child: NumberButton(
                              number: 2,
                              inputNumber: inputNumber,
                              buttonSize: buttonSize)),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: numberPadding['horizontal']!),
                          child: NumberButton(
                              number: 3,
                              inputNumber: inputNumber,
                              buttonSize: buttonSize)),
                    ]),
                  ]))),
      Center(
          child: Padding(
              padding:
                  EdgeInsets.symmetric(vertical: numberPadding['vertical']!),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: numberPadding['horizontal']!),
                          child: NumberButton(
                              number: 4,
                              inputNumber: inputNumber,
                              buttonSize: buttonSize)),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: numberPadding['horizontal']!),
                          child: NumberButton(
                              number: 5,
                              inputNumber: inputNumber,
                              buttonSize: buttonSize)),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: numberPadding['horizontal']!),
                          child: NumberButton(
                              number: 6,
                              inputNumber: inputNumber,
                              buttonSize: buttonSize)),
                    ]),
                  ]))),
      Center(
          child: Padding(
              padding:
                  EdgeInsets.symmetric(vertical: numberPadding['vertical']!),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: numberPadding['horizontal']!),
                          child: NumberButton(
                              number: 7,
                              inputNumber: inputNumber,
                              buttonSize: buttonSize)),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: numberPadding['horizontal']!),
                          child: NumberButton(
                              number: 8,
                              inputNumber: inputNumber,
                              buttonSize: buttonSize)),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: numberPadding['horizontal']!),
                          child: NumberButton(
                              number: 9,
                              inputNumber: inputNumber,
                              buttonSize: buttonSize)),
                    ]),
                  ]))),
      Center(
          child: Padding(
              padding:
                  EdgeInsets.symmetric(vertical: numberPadding['vertical']!),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: numberPadding['horizontal']!),
                          child: SizedBox(
                              height: buttonSize,
                              width: buttonSize,
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      deleteNumber();
                                    });
                                  },
                                  icon: Icon(Icons.backspace,
                                      color: Colors.white,
                                      size: buttonSize / 2)))),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: numberPadding['horizontal']!),
                          child: NumberButton(
                              number: 0,
                              inputNumber: inputNumber,
                              buttonSize: buttonSize)),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: numberPadding['horizontal']!),
                          child: SizedBox(
                              height: buttonSize,
                              width: buttonSize,
                              child: IconButton(
                                  onPressed: () {
                                    if (typedNumbers.length > 4 ||
                                        typedNumbers.length < 8) {
                                      if (authType == 'signin') {
                                        setState(() {
                                          signinNumbers = typedNumbers;
                                          authType = 'confirm';
                                          headLine = 'Retype passcode';
                                          typedNumbers = [];
                                          typedDots = [];
                                        });
                                      } else if (authType == 'confirm') {
                                        if (Compare.list(
                                            signinNumbers, typedNumbers)) {
                                          GoRouter.of(context).go('/listpwd');
                                        }
                                      } else if (authType == 'login') {
                                        if (Compare.list(
                                            data['pass_code'], typedNumbers)) {
                                          GoRouter.of(context).go('/listpwd');
                                        }
                                      }
                                    }
                                  },
                                  icon: Icon(
                                    Icons.done,
                                    color: Colors.white,
                                    size: buttonSize / 2,
                                  )))),
                    ]),
                  ]))),
    ]))));
  }
}
