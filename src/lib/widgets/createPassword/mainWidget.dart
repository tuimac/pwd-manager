// ignore: file_names
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:src/services/fileio.dart';
import 'dart:developer';

class CreatePassword extends StatefulWidget {
  final Map<String, dynamic> data;
  const CreatePassword({Key? key, required this.data}) : super(key: key);

  @override
  State<CreatePassword> createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  late Map<String, dynamic> data;
  late bool passwordVisible;
  late String primaryKey;

  @override
  void initState() {
    super.initState();
    data = widget.data;
    passwordVisible = true;
  }

  void savePassword(Map<String, dynamic> newPassword) {
    data['passwords'][primaryKey] = newPassword;
    FileIO.saveData(data);
    GoRouter.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    Size uiSize = MediaQuery.of(context).size;
    double uiHeight = uiSize.height;
    double uiWidth = uiSize.width;
    Map<String, dynamic> newPassword = {};
    final formKey = GlobalKey<FormState>();

    return Scaffold(
        appBar: AppBar(
            title: const Text('Create new Password'),
            backgroundColor: const Color.fromARGB(255, 56, 168, 224)),
        body: Center(
            child: SizedBox(
                width: uiWidth * 0.8,
                child: Form(
                    key: formKey,
                    child: Column(children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: uiHeight * 0.035),
                          child: TextFormField(
                            autofocus: true,
                            textInputAction: TextInputAction.next,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: const InputDecoration(
                              filled: true,
                              errorStyle: TextStyle(color: Colors.white),
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
                            validator: (input) {
                              if (input!.isEmpty) {
                                return '"User Name" is empty.';
                              } else {
                                if (data['passwords'].containsKey(input)) {
                                  return '"$input" have already been registered.';
                                } else {
                                  return null;
                                }
                              }
                            },
                            onSaved: (String? value) {
                              primaryKey = value!;
                            },
                          )),
                      Padding(
                          padding: EdgeInsets.only(top: uiHeight * 0.035),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              filled: true,
                              errorStyle: TextStyle(color: Colors.white),
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
                            validator: (input) {
                              if (input!.isEmpty) {
                                return '"User Name" is empty.';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (String? value) {
                              newPassword['username'] = value;
                            },
                          )),
                      Padding(
                          padding: EdgeInsets.only(top: uiHeight * 0.035),
                          child: TextFormField(
                              obscureText: passwordVisible,
                              decoration: InputDecoration(
                                  filled: true,
                                  errorStyle:
                                      const TextStyle(color: Colors.white),
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
                              validator: (input) {
                                if (input!.isEmpty) {
                                  return '"User Name" is empty.';
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (String? value) {
                                newPassword['password'] = value;
                              })),
                      Padding(
                          padding: EdgeInsets.only(top: uiHeight * 0.035),
                          child: TextFormField(
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
                                newPassword['memo'] = value;
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
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                savePassword(newPassword);
                              }
                            },
                            child: const Text('Create'),
                          )),
                    ])))));
  }
}
