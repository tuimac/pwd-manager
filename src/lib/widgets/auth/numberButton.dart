import 'package:flutter/material.dart';

class NumberButton extends StatefulWidget {
  final int number;
  final Function inputNumber;
  final double buttonSize;
  const NumberButton(
      {Key? key,
      required this.number,
      required this.inputNumber,
      required this.buttonSize})
      : super(key: key);

  @override
  State<NumberButton> createState() => _NumberButtonState();
}

class _NumberButtonState extends State<NumberButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: widget.buttonSize,
        width: widget.buttonSize,
        child: ElevatedButton(
            onPressed: () {
              setState(() {
                widget.inputNumber(widget.number);
              });
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                backgroundColor: const Color.fromARGB(255, 119, 168, 208)),
            child: Text(widget.number.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 40))));
  }
}
