// ignore: file_names
import 'package:flutter/material.dart';
import 'package:src/widgets/auth/pinAuth.dart';
import 'package:src/widgets/auth/bioAuth.dart';
import 'dart:developer';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:src/services/fileio.dart';
import 'package:src/utils/sanitizer.dart';

class Authentication extends StatefulWidget {
  const Authentication({Key? key}) : super(key: key);

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  late Map<String, dynamic> data = {};

  @override
  void initState() {
    FileIO.getData.then((value) {
      sanitizeData(value).then((sanitizedData) {
        setState(() {
          data = sanitizedData;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size uiSize = MediaQuery.of(context).size;
    double uiWidth = uiSize.width;

    return Scaffold(
        body: SafeArea(
            child: Center(
                child: data.isEmpty
                    ? LoadingAnimationWidget.discreteCircle(
                        color: Colors.white,
                        size: uiWidth * 0.2,
                      )
                    : data['pass_code'].isEmpty
                        ? PinAuth(data: data, authType: 'signin')
                        : BioAuth())));
  }
}
