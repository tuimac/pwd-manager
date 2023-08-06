import 'package:flutter/material.dart';
import '../services/s3.dart';

class ListItems extends StatelessWidget {
  const ListItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Password Manager')),
        body: Center(
            child: FutureBuilder<String?>(
                future: S3Service.getPasswordFile(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    final error = snapshot.error;
                    return Text(
                      'Errro: $error',
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    );
                  } else if (snapshot.hasData) {
                    String result = snapshot.data!;
                    return Text(
                      result,
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    );
                  } else {
                    return const Text(
                      "しばらくお待ち下さい",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    );
                  }
                })));
  }
}

class $ {}
