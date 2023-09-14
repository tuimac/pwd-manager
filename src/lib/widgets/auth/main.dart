// ignore: file_names
import 'package:flutter/material.dart';
import 'package:src/widgets/auth/numberButton.dart';
import 'package:src/services/fileio.dart';

class Authentication extends StatefulWidget {
  const Authentication({Key? key}) : super(key: key);

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  late Map<String, dynamic> data;
  List<int> typedNumbers = [];
  List<Padding> typedDots = [];
  double buttonSize = 80;
  Map<String, double> numberPadding = {'vertical': 15, 'horizontal': 15};
  double dotsSize = 20;
  double dotsSizePadding = 20;
  double contentsPadding = 50;

  @override
  void initState() {
    FileIO.getData.then((value) {
      setState(() {
        data = value;
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
      if (typedNumbers.length > 0) {
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

  @override
  Widget build(BuildContext context) {
    Size uiSize = MediaQuery.of(context).size;
    double uiHeight = uiSize.height;
    double uiWidth = uiSize.width;

    return Scaffold(
        body: SafeArea(
            child: Center(
                child: Column(children: [
      Padding(
          padding: EdgeInsets.only(top: contentsPadding),
          child: const Text('Type the passcode',
              style: TextStyle(color: Colors.white, fontSize: 35))),
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
                                    setState(() {});
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
