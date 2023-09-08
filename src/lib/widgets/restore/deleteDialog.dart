import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:src/services/fileio.dart';
import 'package:src/utils/dateFormat.dart';

class DeleteDialog extends StatefulWidget {
  final String restoreFileName;

  const DeleteDialog({Key? key, required this.restoreFileName})
      : super(key: key);

  @override
  State<DeleteDialog> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<DeleteDialog> {
  late String restoreFileName;
  bool deleteConfirm = false;

  @override
  void initState() {
    super.initState();
    restoreFileName = widget.restoreFileName;
  }

  @override
  Widget build(BuildContext context) {
    Size uiSize = MediaQuery.of(context).size;
    double uiHeight = uiSize.height;

    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 209, 226, 228),
      title: Text(
          // ignore: prefer_interpolation_to_compose_strings
          'Delete ' + DateConverter.dateForDisplay(restoreFileName) + ' ?'),
      content: SizedBox(
          height: uiHeight * 0.13,
          child: Column(children: [
            const Text('Please type "delete" in the box below.',
                style: TextStyle(fontSize: 14)),
            Padding(padding: EdgeInsets.only(top: uiHeight * 0.035)),
            TextFormField(
                textInputAction: TextInputAction.next,
                onChanged: (input) {
                  if (input == 'delete') {
                    setState(() {
                      deleteConfirm = true;
                    });
                  } else {
                    setState(() {
                      deleteConfirm = false;
                    });
                  }
                },
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 0.1),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black, width: 1.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black, width: 1.0)),
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black, width: 1.0)),
                    hintText: 'delete'))
          ])),
      actions: [
        ElevatedButton.icon(
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
            label: const Text('Delete'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
            ),
            onPressed: deleteConfirm == true
                ? () {
                    setState(() {
                      FileIO.deleteRestoreData(restoreFileName);
                    });
                    GoRouter.of(context).pop();
                  }
                : null)
      ],
    );
  }
}
