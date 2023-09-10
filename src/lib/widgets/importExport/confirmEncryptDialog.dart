import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:src/utils/cipher.dart';
import 'package:src/services/fileio.dart';

class ConfirmEncryptDialog extends StatefulWidget {
  final Map<String, dynamic> data;
  const ConfirmEncryptDialog({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<ConfirmEncryptDialog> createState() => _ConfirmEncryptDialogState();
}

class _ConfirmEncryptDialogState extends State<ConfirmEncryptDialog> {
  late String data;
  late bool isEncrypt;

  @override
  void initState() {
    super.initState();
    data = jsonEncode(widget.data);
  }

  void exportData() async {
    setState(() {
      if (isEncrypt) {
        FileIO.exportDataFile(Cipher.encryptString(data));
      } else {
        FileIO.exportDataFile(data);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 209, 226, 228),
        title: const Text('Do you want to encrypt export file?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              setState(() {
                isEncrypt = true;
              });
              exportData();
              GoRouter.of(context).pop();
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                isEncrypt = false;
              });
              exportData();
              GoRouter.of(context).pop();
            },
            child: const Text('No'),
          ),
        ]);
  }
}
