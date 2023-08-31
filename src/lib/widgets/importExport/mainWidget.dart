// ignore: file_names
import 'package:flutter/material.dart';
import 'package:src/services/fileio.dart';
import 'dart:io';
import 'dart:developer';

class ImportExport extends StatefulWidget {
  const ImportExport({Key? key}) : super(key: key);

  @override
  State<ImportExport> createState() => _ImportExportState();
}

class _ImportExportState extends State<ImportExport> {
  List<bool> isToggleSelected = <bool>[false, true];
  List<Widget> importExport = [
    const Text('Import', style: TextStyle(fontSize: 16)),
    const Text('Export', style: TextStyle(fontSize: 16))
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size uiSize = MediaQuery.of(context).size;
    double uiHeight = uiSize.height;
    double uiWidth = uiSize.width;

    return Scaffold(
        appBar: AppBar(
            title: const Text('Import/Export'),
            backgroundColor: const Color.fromARGB(255, 56, 168, 224)),
        body: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(top: uiHeight * 0.03),
                child: Center(
                    child: ToggleButtons(
                  direction: Axis.horizontal,
                  onPressed: (int index) {
                    for (int i = 0; i < isToggleSelected.length; i++) {
                      setState(() {
                        isToggleSelected[i] = !isToggleSelected[i];
                      });
                    }
                  },
                  selectedBorderColor: const Color.fromARGB(255, 197, 217, 229),
                  selectedColor: const Color.fromARGB(255, 197, 217, 229),
                  fillColor: const Color.fromARGB(255, 105, 116, 203),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  color: const Color.fromARGB(255, 197, 217, 229),
                  constraints: BoxConstraints(
                    minHeight: uiHeight * 0.05,
                    minWidth: uiWidth * 0.3,
                  ),
                  isSelected: isToggleSelected,
                  children: importExport,
                ))),
            isToggleSelected[0]
                ? Padding(
                    padding: EdgeInsets.only(top: uiHeight * 0.03),
                    child: Container(
                      child: ElevatedButton(
                        child: const Text('Button'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {},
                      ),
                    ))
                : Padding(
                    padding: EdgeInsets.only(top: uiHeight * 0.03),
                    child: Container())
          ],
        ));
  }
}
