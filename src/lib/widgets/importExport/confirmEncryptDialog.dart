import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:src/services/dataFileIO.dart';

class ConfirmEncryptDialog extends StatefulWidget {
  final Map<String, dynamic> data;
  const ConfirmEncryptDialog({
    super.key,
    required this.data,
  });

  @override
  State<ConfirmEncryptDialog> createState() => _ConfirmEncryptDialogState();
}

class _ConfirmEncryptDialogState extends State<ConfirmEncryptDialog> {
  late Map<String, dynamic> data;
  late bool isEncrypt = false;
  late bool passwordVisible;

  @override
  void initState() {
    super.initState();
    data = widget.data;
    passwordVisible = true;
  }

  void exportData(bool isEncrypt) {
    DataFileIO.exportDataFile(data, isEncrypt);
  }

  @override
  Widget build(BuildContext context) {
    double textSize = 15;

    return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 209, 226, 228),
        title: Text(
            isEncrypt
                ? 'Type password to encrypt file.'
                : 'Do you want to encrypt the export file?',
            style: TextStyle(fontSize: textSize)),
        content: isEncrypt
            ? SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextFormField(
                    obscureText: passwordVisible,
                    style: TextStyle(fontSize: textSize),
                    decoration: InputDecoration(
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        fillColor: const Color.fromARGB(255, 113, 141, 157),
                        enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2.0)),
                        focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2.0)),
                        border: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2.0)),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Password',
                        labelStyle: const TextStyle(
                          color: Colors.white,
                        ),
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
                    cursorColor: Colors.black,
                    onSaved: (String? value) {}))
            : SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.8),
        actions: isEncrypt
            ? <Widget>[
                TextButton(
                  onPressed: () {
                    exportData(true);
                    GoRouter.of(context).pop();
                  },
                  child: const Text('Export'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isEncrypt = false;
                    });
                  },
                  child: const Text('Cancel'),
                )
              ]
            : <Widget>[
                TextButton(
                  onPressed: () {
                    setState(() {
                      isEncrypt = true;
                    });
                  },
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    exportData(false);
                    GoRouter.of(context).pop();
                  },
                  child: const Text('No'),
                )
              ]);
  }
}
