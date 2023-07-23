import 'package:flutter/material.dart';

class LayoutWidget extends StatelessWidget {
  final String title;

  const LayoutWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(title),
    );
  }
}
