// ignore: file_names
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
<<<<<<< HEAD
import 'package:src/utils/dateFormat.dart';
import 'package:src/utils/passwordGen.dart';
import 'package:src/services/fileio.dart';
import 'dart:developer';
=======
import 'package:src/services/dataFileIO.dart';
>>>>>>> ad876582df9d66bfeda6f37c78853e6862b2b3d5

class CreatePassword extends StatefulWidget {
  final Map<String, dynamic> data;
  const CreatePassword({super.key, required this.data});

  @override
  State<CreatePassword> createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  late Map<String, dynamic> data;
  late bool passwordVisible;
  late String primaryKey;
  final formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    data = widget.data;
    passwordVisible = true;
  }

  void savePassword(Map<String, dynamic> newPassword) async {
    setState(() {
<<<<<<< HEAD
      data['passwords'][primaryKey] = newPassword;
      data['passwords'][primaryKey]['watch_time'] = DateConverter.getNow();
      data['passwords'][primaryKey]['created_time'] = DateConverter.getNow();
      data['passwords'][primaryKey]['mod_time'] = DateConverter.getNow();
      FileIO.saveData(data).then((value) => GoRouter.of(context).pop());
=======
      data[primaryKey] = newPassword;
      String now = DateTime.now().toIso8601String();
      data[primaryKey]['create_timestamp'] = now;
      data[primaryKey]['modify_timestamp'] = now;
      data[primaryKey]['watch_timestamp'] = now;
      DataFileIO.saveData(data).then((value) => GoRouter.of(context).pop());
>>>>>>> ad876582df9d66bfeda6f37c78853e6862b2b3d5
    });
  }

  @override
  Widget build(BuildContext context) {
    Size uiSize = MediaQuery.of(context).size;
    double uiHeight = uiSize.height;
    double uiWidth = uiSize.width;
    Map<String, dynamic> newPassword = {};
    double paddingTop = uiHeight * 0.02;
    double textSize = 15;
    Map<String, double> contentPadding = {'y': 4, 'x': 10};

    return Scaffold(
        appBar: AppBar(
            title: const Text('Create new Password'),
            backgroundColor: const Color.fromARGB(255, 56, 168, 224)),
        body: SafeArea(
            maintainBottomViewPadding: true,
            child: SingleChildScrollView(
                child: Center(
                    child: SizedBox(
                        width: uiWidth * 0.8,
                        child: Form(
                            key: formKey,
                            child: Column(children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(top: paddingTop),
                                  child: TextFormField(
                                    style: TextStyle(fontSize: textSize),
                                    autofocus: true,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.text,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                      filled: true,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: contentPadding['y']!,
                                        horizontal: contentPadding['x']!,
                                      ),
                                      errorStyle:
                                          const TextStyle(color: Colors.white),
                                      fillColor: const Color.fromARGB(
                                          255, 142, 164, 231),
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 2.0)),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 2.0)),
                                      border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 2.0)),
                                      labelText: 'Password Name',
                                      labelStyle:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    cursorColor: Colors.white,
                                    validator: (input) {
                                      if (input!.isEmpty) {
                                        return '"Password Name" is empty.';
                                      } else {
                                        if (data.containsKey(input)) {
                                          return '"$input" have already been registered.';
                                        } else {
                                          if (input.contains('?')) {
                                            return 'This field cannot contain "?".';
                                          } else {
                                            return null;
                                          }
                                        }
                                      }
                                    },
                                    onSaved: (String? value) {
                                      primaryKey = value!;
                                    },
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(top: paddingTop),
                                  child: TextFormField(
                                    style: TextStyle(fontSize: textSize),
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      filled: true,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: contentPadding['y']!,
                                        horizontal: contentPadding['x']!,
                                      ),
                                      errorStyle:
                                          const TextStyle(color: Colors.white),
                                      fillColor: const Color.fromARGB(
                                          255, 158, 158, 158),
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 2.0)),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 2.0)),
                                      border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 2.0)),
                                      labelText: 'User Name',
                                      labelStyle:
                                          const TextStyle(color: Colors.white),
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
                                  padding: EdgeInsets.only(top: paddingTop),
                                  child: TextFormField(
                                      style: TextStyle(fontSize: textSize),
                                      obscureText: passwordVisible,
                                      textInputAction: TextInputAction.next,
                                      controller: passwordController,
                                      decoration: InputDecoration(
                                          filled: true,
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: contentPadding['y']!,
                                            horizontal: contentPadding['x']!,
                                          ),
                                          errorStyle: const TextStyle(
                                              color: Colors.white),
                                          fillColor: const Color.fromARGB(
                                              255, 158, 158, 158),
                                          enabledBorder:
                                              const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white,
                                                      width: 2.0)),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white,
                                                      width: 2.0)),
                                          border: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 2.0)),
                                          labelText: 'Password',
                                          labelStyle: const TextStyle(
                                              color: Colors.white),
                                          suffixIcon: IconButton(
                                            icon: Icon(passwordVisible
                                                ? Icons.visibility_off
                                                : Icons.visibility),
                                            onPressed: () {
                                              setState(() {
                                                passwordVisible =
                                                    !passwordVisible;
                                              });
                                            },
                                          )),
                                      cursorColor: Colors.white,
                                      validator: (input) {
                                        if (input!.isEmpty) {
                                          return '"Password" is empty.';
                                        } else {
                                          return null;
                                        }
                                      },
                                      onSaved: (String? value) {
                                        newPassword['password'] = value;
                                      })),
                              Padding(
                                  padding: const EdgeInsets.only(top: 0),
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                            height: 30,
                                            width: 120,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.black,
                                                backgroundColor:
                                                    Colors.blue[300],
                                              ),
                                              onPressed: () {
                                                log(data['settings']
                                                    .toString());
                                                setState(() {
                                                  passwordController.text =
                                                      PasswordGen.genPassword(data[
                                                              'settings'][
                                                          'auto_pwd_gen_rule']);
                                                });
                                              },
                                              child: const Text('GenPassword'),
                                            )),
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.settings,
                                            color: Colors.white,
                                          ),
                                        )
                                      ])),
                              Padding(
                                  padding: EdgeInsets.only(top: 0),
                                  child: TextFormField(
                                      style: TextStyle(fontSize: textSize),
                                      decoration: InputDecoration(
                                        filled: true,
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: contentPadding['x']!,
                                        ),
                                        fillColor: const Color.fromARGB(
                                            255, 113, 141, 157),
                                        enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2.0)),
                                        focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2.0)),
                                        border: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2.0)),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        labelText: 'Memo',
                                        labelStyle: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      maxLines: 10,
                                      minLines: 5,
                                      cursorColor: Colors.black,
                                      onSaved: (String? value) {
                                        newPassword['memo'] = value;
                                      })),
                              Padding(
                                  padding: EdgeInsets.only(top: paddingTop),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.black,
                                      backgroundColor: const Color.fromARGB(
                                          255, 87, 180, 90),
                                    ),
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        formKey.currentState!.save();
                                        savePassword(newPassword);
                                      }
                                    },
                                    child: const Text('Create'),
                                  )),
                            ])))))));
  }
}
