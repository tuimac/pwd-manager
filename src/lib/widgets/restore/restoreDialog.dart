import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:src/utils/dateFormat.dart';
import 'package:src/services/dataFileIO.dart';

class RestoreDialog extends StatefulWidget {
  final String restoreTarget;
  const RestoreDialog({Key? key, required this.restoreTarget})
      : super(key: key);

  @override
  State<RestoreDialog> createState() => _RestoreDialogState();
}

class _RestoreDialogState extends State<RestoreDialog> {
  late String restoreTarget;

  @override
  void initState() {
    super.initState();
    restoreTarget = widget.restoreTarget;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 209, 226, 228),
      title: Text('Restore $restoreTarget ?'),
      actions: [
        ElevatedButton.icon(
            icon: const Icon(
              Icons.restore,
              color: Colors.white,
            ),
            label: const Text('Restore'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
            ),
            onPressed: (() {
              DataFileIO.restoreData(
                  DateConverter.dateForFileName(restoreTarget));
              GoRouter.of(context).pop();
              GoRouter.of(context).pop();
            })),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: const Color.fromARGB(255, 87, 180, 90),
          ),
          onPressed: () {
            GoRouter.of(context).pop();
          },
          child: const Text('Cancel'),
        )
      ],
    );
  }
}
