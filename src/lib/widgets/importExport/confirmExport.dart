import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:src/config/config.dart';
import 'package:src/services/dataFileIO.dart';
import 'package:src/services/logFileIo.dart';

class ConfirmExport extends StatefulWidget {
  final Map<String, dynamic> data;
  const ConfirmExport({
    super.key,
    required this.data,
  });

  @override
  State<ConfirmExport> createState() => _ConfirmExportState();
}

class _ConfirmExportState extends State<ConfirmExport> {
  late Map<String, dynamic> data;
  late bool isEncrypt = false;
  late bool passwordVisible;
  late String password = '';

  @override
  void initState() {
    super.initState();
    data = widget.data;
    passwordVisible = true;
  }

  void exportData() {
    if (isEncrypt) {
      LogFileIO.logging(isEncrypt.toString());
      DataFileIO.exportDataFile(data, password: password).then((value) async {
        FilePicker.platform.pickFiles(
            initialDirectory: await Config.getDownloadDir,
            type: FileType.custom,
            allowedExtensions: ['json']);
      });
    } else {
      DataFileIO.exportDataFile(data).then((value) async {
        FilePicker.platform.pickFiles(
            initialDirectory: await Config.getDownloadDir,
            type: FileType.custom,
            allowedExtensions: ['json']);
      });
    }
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
                child: TextField(
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
        actions: isEncrypt
            ? <Widget>[
                TextButton(
                  onPressed: () {
                    exportData();
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
                  child: const Text('yes'),
                ),
                TextButton(
                  onPressed: () {
                    GoRouter.of(context).pop();
                  },
                  child: const Text('No'),
                )
              ]);
  }
}
