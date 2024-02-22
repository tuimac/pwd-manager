import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:src/services/dataFileIO.dart';
import 'package:src/services/logFileIo.dart';

class ConfirmImport extends StatefulWidget {
  final Map<String, dynamic> data;
  const ConfirmImport({
    super.key,
    required this.data,
  });

  @override
  State<ConfirmImport> createState() => _ConfirmImportState();
}

class _ConfirmImportState extends State<ConfirmImport> {
  late Map<String, dynamic> data;
  late bool passwordVisible;
  late String password = '';

  @override
  void initState() {
    super.initState();
    data = widget.data;
    passwordVisible = true;
  }

  void importData() async {
    try {
      if (data['encryption'] || data.containsKey('encryption')) {
        DataFileIO.importDataFile(data, password: password).then((value) {
          GoRouter.of(context).pop();
          GoRouter.of(context).pop();
        });
      } else {
        DataFileIO.importDataFile(data).then((value) {
          GoRouter.of(context).pop();
          GoRouter.of(context).pop();
        });
      }
    } catch (e) {
      LogFileIO.logging(e.toString());
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    double textSize = 15;

    return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 209, 226, 228),
        title: Text(
            data['encryption']
                ? 'Type password to encrypt file.'
                : 'Are you sure import data?',
            style: TextStyle(fontSize: textSize)),
        content: data['encryption']
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
                    onChanged: (input) {
                      setState(() {
                        password = input;
                      });
                    }))
            : SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.8),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              importData();
            },
            child: const Text('Import'),
          ),
          TextButton(
            onPressed: () {
              GoRouter.of(context).pop();
            },
            child: const Text('Cancel'),
          )
        ]);
  }
}
