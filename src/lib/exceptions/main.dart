import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ExceptionDialog extends StatefulWidget {
  final String messages;
  const ExceptionDialog({Key? key, required this.messages}) : super(key: key);

  @override
  State<ExceptionDialog> createState() => _ExceptionDialogState();
}

class _ExceptionDialogState extends State<ExceptionDialog> {
  late String messages;

  @override
  void initState() {
    messages = widget.messages;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 209, 226, 228),
      title: const Text('Throwed exception!'),
      content: Text(messages),
      actions: [
        TextButton(
          onPressed: () {
            GoRouter.of(context).pop();
          },
          child: const Text('OK'),
        )
      ],
    );
  }
}
