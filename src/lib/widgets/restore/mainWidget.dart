// ignore: file_names
import 'package:flutter/material.dart';
import 'package:src/services/fileio.dart';
import 'package:src/widgets/restore/restoreDialog.dart';
import 'dart:developer';

class Restore extends StatefulWidget {
  const Restore({Key? key}) : super(key: key);

  @override
  State<Restore> createState() => _RestoreState();
}

class _RestoreState extends State<Restore> {
  final formKey = GlobalKey<FormState>();
  late List<String> restoreDataList = [];

  @override
  void initState() {
    getRestoreDataList();
    super.initState();
  }

  void getRestoreDataList() async {
    await FileIO.getRestoreInfo().then((result) {
      setState(() {
        restoreDataList = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size uiSize = MediaQuery.of(context).size;
    double uiHeight = uiSize.height;

    return Scaffold(
        appBar: AppBar(
            title: const Text('Restore Data List'),
            backgroundColor: const Color.fromARGB(255, 56, 168, 224)),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: uiHeight * 0.03),
                    itemCount: restoreDataList.length,
                    itemBuilder: (context, index) {
                      return Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey),
                            ),
                          ),
                          child: ListTile(
                              title: Text(restoreDataList[index],
                                  style: const TextStyle(color: Colors.white)),
                              onTap: () async {
                                return await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return RestoreDialog(
                                          restoreTarget:
                                              restoreDataList[index]);
                                    });
                              }));
                    }))
          ],
        ))));
  }
}
