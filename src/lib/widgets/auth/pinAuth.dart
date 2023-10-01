import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:src/utils/compare.dart';
import 'package:go_router/go_router.dart';

class PinAuth extends StatefulWidget {
  final Map<String, dynamic> data;
  final String authType;
  const PinAuth({Key? key, required this.data, required this.authType})
      : super(key: key);

  @override
  State<PinAuth> createState() => _PinAuthState();
}

class _PinAuthState extends State<PinAuth> {
  late Map<String, dynamic> data;
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

  @override
  void initState() {
    super.initState();
    setState(() {
      authType = widget.authType;
    });
    setState(() {
      if (authType == 'signin') {
        headLine = 'Register passcode.';
      } else if (authType == 'login') {
        headLine = 'Type passcode';
      } else {
        headLine = 'Loading';
      }
    });
    data = widget.data;
    log(widget.data.toString());
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
        }
      } else if (authType == 'login') {
        if (Compare.list(data['pass_code'], typedNumbers)) {
          GoRouter.of(context).go('/listpwd', extra: data);
        }
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(padding: EdgeInsets.only(top: contentsPadding)),
      Padding(
          padding: EdgeInsets.only(top: contentsPadding),
          child: Text(headLine,
              style: const TextStyle(color: Colors.white, fontSize: 30))),
      Padding(padding: EdgeInsets.only(top: contentsPadding + dotsSizePadding)),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: typedDots),
      Padding(padding: EdgeInsets.only(top: contentsPadding)),
      Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        for (var rowButtons in buttonMap) ...[
          Padding(
              padding:
                  EdgeInsets.symmetric(vertical: numberPadding['vertical']!),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                for (var buttonContent in rowButtons) ...[
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: numberPadding['horizontal']!),
                      child: SizedBox(
                          height: buttonSize,
                          width: buttonSize,
                          child: (() {
                            if (buttonContent == 'Delete') {
                              return IconButton(
                                  onPressed: () {
                                    deleteNumber();
                                  },
                                  icon: Icon(Icons.backspace,
                                      color: Colors.white,
                                      size: buttonSize / 2));
                            } else if (buttonContent == 'Enter') {
                              return IconButton(
                                  onPressed: () {
                                    tryLogin();
                                  },
                                  icon: Icon(
                                    Icons.done,
                                    color: Colors.white,
                                    size: buttonSize / 2,
                                  ));
                            } else {
                              return ElevatedButton(
                                  onPressed: () {
                                    inputNumber(buttonContent);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      backgroundColor: const Color.fromARGB(
                                          255, 119, 168, 208)),
                                  child: Text(buttonContent.toString(),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 40)));
                            }
                          })()))
                ]
              ]))
        ]
      ]))
    ]);
  }
}
