// ignore: file_names
import 'package:flutter/material.dart';

class CreatePassword extends StatefulWidget {
  final Map<String, dynamic> data;
  const CreatePassword({Key? key, required this.data}) : super(key: key);

  @override
  State<CreatePassword> createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  late Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();
    data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    Size uiSize = MediaQuery.of(context).size;
    double uiHeight = uiSize.height;
    double uiWidth = uiSize.width;

    return Scaffold(
        appBar: AppBar(title: const Text('Password Manager')),
        body: Center(
            child: SizedBox(
                width: uiWidth * 0.8,
                child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Column(children: <Widget>[
                      TextFormField(
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white, width: 2.0)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white, width: 2.0)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white, width: 2.0)),
                            labelText: 'Password Name',
                            labelStyle: TextStyle(
                                color: Color.fromARGB(255, 158, 155, 155)),
                            suffixIcon: Icon(
                              Icons.check_circle,
                            ),
                          ),
                          cursorColor: Colors.white)
                    ])))));
  }
}
