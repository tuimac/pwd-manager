import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:src/services/logFileIo.dart';

class SystemLogs extends StatefulWidget {
  const SystemLogs({super.key});

  @override
  State<SystemLogs> createState() => _SystemLogsState();
}

class _SystemLogsState extends State<SystemLogs> {
  late String log = '';

  @override
  void initState() {
    super.initState();
    LogFileIO.getLog().then((result) => setState(() {
          log = result;
        }));
  }

  @override
  Widget build(BuildContext context) {
    Size uiSize = MediaQuery.of(context).size;
    double uiHeight = uiSize.height;

    return Scaffold(
        appBar: AppBar(
            title: const Text('System Log'),
            backgroundColor: const Color.fromARGB(255, 56, 168, 224)),
        body: log.isEmpty
            ? Center(
                child: LoadingAnimationWidget.discreteCircle(
                color: Colors.white,
                size: MediaQuery.of(context).size.height * 0.2,
              ))
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: SizedBox(
                    height: uiHeight,
                    child: TextField(
                        readOnly: false,
                        controller: TextEditingController(text: log),
                        style: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          fillColor: Color.fromARGB(255, 113, 141, 157),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0)),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0)),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        minLines: 20,
                        maxLines: 20))));
  }
}
