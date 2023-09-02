// ignore: file_names
import 'package:flutter/material.dart';
import 'package:src/services/fileio.dart';

class Restore extends StatefulWidget {
  const Restore({Key? key}) : super(key: key);

  @override
  State<Restore> createState() => _RestoreState();
}

class _RestoreState extends State<Restore> {
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size uiSize = MediaQuery.of(context).size;
    double uiHeight = uiSize.height;
    double uiWidth = uiSize.width;
    double paddingTop = uiHeight * 0.01;

    return Scaffold(
        appBar: AppBar(
            title: const Text('Restore'),
            backgroundColor: const Color.fromARGB(255, 56, 168, 224)),
        body: SingleChildScrollView(
            child: Center(
                child: Form(
                    key: formKey,
                    child: Padding(
                        padding: EdgeInsets.only(top: paddingTop),
                        child: TextFormField(
                            keyboardType: TextInputType.number,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: const InputDecoration(
                              filled: true,
                              errorStyle: TextStyle(color: Colors.white),
                              fillColor: Color.fromARGB(255, 142, 164, 231),
                              labelText: 'Password Name',
                              labelStyle: TextStyle(color: Colors.white),
                            )))))));
  }
}
