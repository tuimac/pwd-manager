// ignore: file_names
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:src/services/fileio.dart';
import 'dart:developer';

class EditPassword extends StatefulWidget {
  final String primaryKey;
  final Map<String, dynamic> data;
  const EditPassword({Key? key, required this.primaryKey, required this.data})
      : super(key: key);

  @override
  State<EditPassword> createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  late Map<String, dynamic> data;
  late String primaryKey;
  late bool passwordVisible;

  @override
  void initState() {
    super.initState();
    data = widget.data;
    primaryKey = widget.primaryKey;
    passwordVisible = true;
  }

  void savePassword() {
    FileIO.saveData(data);
    GoRouter.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    Size uiSize = MediaQuery.of(context).size;
    double uiHeight = uiSize.height;
    double uiWidth = uiSize.width;
    final formKey = GlobalKey<FormState>();

    return Scaffold(
        appBar: AppBar(title: const Text('Password Manager')),
        body: Center(
            child: SizedBox(
                width: uiWidth * 0.8,
                child: Form(
                    key: formKey,
                    child: Column(children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: uiHeight * 0.035),
                          child: TextFormField(
                            initialValue: primaryKey,
                            autofocus: true,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color.fromARGB(255, 142, 164, 231),
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
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                            cursorColor: Colors.white,
                            onSaved: (String? value) {
                              data['passwords'][primaryKey]['name'] = value;
                            },
                          )),
                      Padding(
                          padding: EdgeInsets.only(top: uiHeight * 0.035),
                          child: TextFormField(
                            initialValue: data['passwords'][primaryKey]
                                ['username'],
                            autofocus: true,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color.fromARGB(255, 158, 158, 158),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2.0)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2.0)),
                              labelText: 'User Name',
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                            cursorColor: Colors.white,
                            onSaved: (String? value) {
                              data['passwords'][primaryKey]['username'] = value;
                            },
                          )),
                      Padding(
                          padding: EdgeInsets.only(top: uiHeight * 0.035),
                          child: TextFormField(
                              initialValue: data['passwords'][primaryKey]
                                  ['password'],
                              obscureText: passwordVisible,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor:
                                      const Color.fromARGB(255, 158, 158, 158),
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 2.0)),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 2.0)),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 2.0)),
                                  labelText: 'Password',
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                  suffixIcon: IconButton(
                                    icon: Icon(passwordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () {
                                      setState(() {
                                        passwordVisible = !passwordVisible;
                                      });
                                    },
                                  )),
                              cursorColor: Colors.white,
                              onSaved: (String? value) {
                                data['passwords'][primaryKey]['password'] =
                                    value;
                              })),
                      Padding(
                          padding: EdgeInsets.only(top: uiHeight * 0.035),
                          child: TextFormField(
                              initialValue: data['passwords'][primaryKey]
                                  ['memo'],
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Color.fromARGB(255, 113, 141, 157),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2.0)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2.0)),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2.0)),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: 'Memo',
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              maxLines: 20,
                              minLines: 10,
                              cursorColor: Colors.black,
                              onSaved: (String? value) {
                                data['passwords'][primaryKey]['memo'] = value;
                              })),
                      Padding(
                          padding: EdgeInsets.only(top: uiHeight * 0.035),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor:
                                  const Color.fromARGB(255, 87, 180, 90),
                            ),
                            onPressed: () {
                              formKey.currentState!.save();
                              savePassword();
                            },
                            child: const Text('Save'),
                          )),
                    ])))));
  }
}
