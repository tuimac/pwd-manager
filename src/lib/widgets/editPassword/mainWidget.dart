// ignore: file_names
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/fileio.dart';

class EditPassword extends StatefulWidget {
  final Map<String, dynamic> data;
  final int dataIndex;
  const EditPassword({Key? key, required this.data, required this.dataIndex})
      : super(key: key);

  @override
  State<EditPassword> createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  late Map<String, dynamic> passwordData;
  late int dataIndex;
  late bool passwordVisible;

  @override
  void initState() {
    super.initState();
    passwordData = widget.data;
    dataIndex = widget.dataIndex;
    passwordVisible = true;
  }

  void savePassword(passwordData) {
    FileIO.savePassword(passwordData);
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
                            initialValue: passwordData['passwords'][dataIndex]
                                ['name'],
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
                              passwordData['passwords'][dataIndex]['name'] =
                                  value;
                            },
                          )),
                      Padding(
                          padding: EdgeInsets.only(top: uiHeight * 0.035),
                          child: TextFormField(
                            initialValue: passwordData['passwords'][dataIndex]
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
                              passwordData['passwords'][dataIndex]['username'] =
                                  value;
                            },
                          )),
                      Padding(
                          padding: EdgeInsets.only(top: uiHeight * 0.035),
                          child: TextFormField(
                              initialValue: passwordData['passwords'][dataIndex]
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
                                passwordData['passwords'][dataIndex]
                                    ['password'] = value;
                              })),
                      Padding(
                          padding: EdgeInsets.only(top: uiHeight * 0.035),
                          child: TextFormField(
                              initialValue: passwordData['passwords'][dataIndex]
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
                                passwordData['passwords'][dataIndex]['memo'] =
                                    value;
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
                              savePassword(passwordData);
                            },
                            child: const Text('Save'),
                          )),
                    ])))));
  }
}
