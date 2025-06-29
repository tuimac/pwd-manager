// ignore: file_names
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:src/services/logFileIo.dart';
import 'package:src/widgets/importExport/confirmImport.dart';
import 'package:src/widgets/importExport/confirmExport.dart';

class ImportExport extends StatefulWidget {
  final Map<String, dynamic> data;
  const ImportExport({super.key, required this.data});

  @override
  State<ImportExport> createState() => _ImportExportState();
}

class _ImportExportState extends State<ImportExport> {
  late Map<String, dynamic> data;
  List<bool> isToggleSelected = <bool>[true, false];
  List<Widget> importExport = [
    const Text('Import', style: TextStyle(fontSize: 16)),
    const Text('Export', style: TextStyle(fontSize: 16))
  ];
  String buttonText = 'Choose Import File';
  late Map<String, dynamic> switcher = {
    'import': {
      'text': {'switch': false, 'content': ''},
      'button': {
        'text': 'Choose Import File',
        'color': Colors.blue,
        'import': false
      }
    },
    'export': {
      'button': {
        'text': 'Export File',
        'color': const Color.fromARGB(255, 82, 218, 231)
      }
    }
  };

  @override
  void initState() {
    super.initState();
    data = widget.data;
  }

  void chooseFile() {
    try {
      FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['json']).then((importFile) {
        if (importFile != null) {
          File(importFile.files.single.path!).readAsString().then((data) {
            setState(() {
              switcher['import']['text']['content'] = data;
              switcher['import']['text']['switch'] = true;
              switcher['import']['button']['import'] = true;
              switcher['import']['button']['text'] = 'Import Data';
              switcher['import']['button']['color'] = Colors.green;
            });
          });
        }
      });
    } catch (e) {
      LogFileIO.logging(e.toString());
      rethrow;
    }
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
                        switcher['import']['text']['content'] = '';
                        switcher['import']['text']['switch'] = false;
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
                // Import data section
                ? Column(children: [
                    Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: uiHeight * 0.015,
                            horizontal: uiWidth * 0.1),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: switcher['import']['button']
                                ['color'],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            if (switcher['import']['button']['import']) {
                              return await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ConfirmImport(
                                        data: jsonDecode(switcher['import']
                                            ['text']['content']));
                                  });
                            } else {
                              chooseFile();
                            }
                          },
                          child: Text(switcher['import']['button']['text']),
                        )),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: uiHeight * 0.015,
                            horizontal: uiWidth * 0.01),
                        child: switcher['import']['text']['switch']
                            ? TextField(
                                readOnly: true,
                                controller: TextEditingController(
                                    text: switcher['import']['text']
                                        ['content']),
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Color.fromARGB(255, 113, 141, 157),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 2.0)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 2.0)),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 2.0)),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                                maxLines: 14,
                                minLines: 14,
                                cursorColor: Colors.black)
                            : Container())
                  ])
                // Export data section
                : Padding(
                    padding: EdgeInsets.only(top: uiHeight * 0.015),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: switcher['export']['button']['color'],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ConfirmExport(data: data);
                            });
                      },
                      child: Text(switcher['export']['button']['text']),
                    )),
          ],
        ));
  }
}
