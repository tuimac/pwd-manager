// ignore: file_names
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:src/services/dataFileIO.dart';

class EditPassword extends StatefulWidget {
  final String primaryKey;
  final Map<String, dynamic> data;
  const EditPassword({Key? key, required this.primaryKey, required this.data})
      : super(key: key);

  @override
  State<EditPassword> createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  late Map<String, dynamic> data;
  late String primaryKey;
  late bool passwordVisible;
  final formKey = GlobalKey<FormState>();
  late Map<String, dynamic> editFlags = {
    'readOnly': true,
    'autoFocus': false,
    'buttonText': '(ReadOnly mode)',
  };

  @override
  void initState() {
    super.initState();
    data = widget.data;
    primaryKey = widget.primaryKey;
    passwordVisible = true;
  }

  void savePassword(Map<String, dynamic> editedPassword) {
    setState(() {
      data[primaryKey] = editedPassword;
      DataFileIO.saveData(data).then((value) => GoRouter.of(context).pop());
    });
  }

  void timeStamp() async {}

  void switchEdit() {
    if (editFlags['readOnly']) {
      setState(() {
        editFlags['readOnly'] = false;
        editFlags['autoFocus'] = true;
      });
    } else {
      setState(() {
        editFlags['readOnly'] = true;
        editFlags['autoFocus'] = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size uiSize = MediaQuery.of(context).size;
    double uiHeight = uiSize.height;
    double uiWidth = uiSize.width;
    Map<String, dynamic> editedPassword = {};
    double paddingTop = uiHeight * 0.02;
    double textSize = 16;
    Map<String, double> contentPadding = {'y': 4, 'x': 10};

    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Password'),
          backgroundColor: const Color.fromARGB(255, 56, 168, 224),
          actions: [
            editFlags['readOnly']
                ? IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      switchEdit();
                    },
                  )
                : TextButton(
                    onPressed: () {
                      switchEdit();
                    },
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.white)))
          ],
        ),
        body: SafeArea(
            maintainBottomViewPadding: true,
            child: SingleChildScrollView(
                child: Center(
                    child: SizedBox(
                        width: uiWidth * 0.8,
                        child: Form(
                            key: formKey,
                            child: SingleChildScrollView(
                                child: Column(children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(top: paddingTop),
                                  child: TextFormField(
                                    readOnly: editFlags['readOnly']!,
                                    style: TextStyle(fontSize: textSize),
                                    autofocus: editFlags['autoFocus']!,
                                    textInputAction: TextInputAction.next,
                                    initialValue: primaryKey,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                      filled: true,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: contentPadding['y']!,
                                        horizontal: contentPadding['x']!,
                                      ),
                                      errorStyle:
                                          const TextStyle(color: Colors.white),
                                      fillColor: const Color.fromARGB(
                                          255, 142, 164, 231),
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 2.0)),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 2.0)),
                                      border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 2.0)),
                                      labelText: 'Password Name',
                                      labelStyle:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    cursorColor: Colors.white,
                                    validator: (input) {
                                      if (input!.isEmpty) {
                                        return '"User Name" is empty.';
                                      } else {
                                        if (data.containsKey(input) &&
                                            input != primaryKey) {
                                          return '"$input" have already been registered.';
                                        } else {
                                          return null;
                                        }
                                      }
                                    },
                                    onSaved: (String? value) {
                                      if (primaryKey != value) {
                                        data.remove(primaryKey);
                                        primaryKey = value!;
                                      }
                                    },
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(top: paddingTop),
                                  child: TextFormField(
                                    readOnly: editFlags['readOnly']!,
                                    style: TextStyle(fontSize: textSize),
                                    initialValue: data[primaryKey]['username'],
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      filled: true,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: contentPadding['y']!,
                                        horizontal: contentPadding['x']!,
                                      ),
                                      errorStyle:
                                          const TextStyle(color: Colors.white),
                                      fillColor: const Color.fromARGB(
                                          255, 158, 158, 158),
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 2.0)),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 2.0)),
                                      border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 2.0)),
                                      labelText: 'User Name',
                                      labelStyle:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    cursorColor: Colors.white,
                                    validator: (input) {
                                      if (input!.isEmpty) {
                                        return '"User Name" is empty.';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (String? value) {
                                      editedPassword['username'] = value;
                                    },
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(top: paddingTop),
                                  child: TextFormField(
                                      readOnly: editFlags['readOnly']!,
                                      style: TextStyle(fontSize: textSize),
                                      initialValue: data[primaryKey]
                                          ['password'],
                                      textInputAction: TextInputAction.next,
                                      obscureText: passwordVisible,
                                      decoration: InputDecoration(
                                          filled: true,
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: contentPadding['y']!,
                                            horizontal: contentPadding['x']!,
                                          ),
                                          fillColor: const Color.fromARGB(
                                              255, 158, 158, 158),
                                          errorStyle: const TextStyle(
                                              color: Colors.white),
                                          enabledBorder:
                                              const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white,
                                                      width: 2.0)),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white,
                                                      width: 2.0)),
                                          border: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 2.0)),
                                          labelText: 'Password',
                                          labelStyle: const TextStyle(
                                              color: Colors.white),
                                          suffixIcon: IconButton(
                                            icon: Icon(passwordVisible
                                                ? Icons.visibility_off
                                                : Icons.visibility),
                                            onPressed: () {
                                              setState(() {
                                                passwordVisible =
                                                    !passwordVisible;
                                              });
                                            },
                                          )),
                                      cursorColor: Colors.white,
                                      validator: (input) {
                                        if (input!.isEmpty) {
                                          return '"User Name" is empty.';
                                        } else {
                                          return null;
                                        }
                                      },
                                      onSaved: (String? value) {
                                        editedPassword['password'] = value;
                                      })),
                              Padding(
                                  padding: EdgeInsets.only(top: paddingTop),
                                  child: TextFormField(
                                      readOnly: editFlags['readOnly']!,
                                      style: TextStyle(fontSize: textSize),
                                      initialValue: data[primaryKey]['memo'],
                                      decoration: InputDecoration(
                                        filled: true,
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: contentPadding['x']!,
                                        ),
                                        fillColor: const Color.fromARGB(
                                            255, 113, 141, 157),
                                        enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2.0)),
                                        focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2.0)),
                                        border: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2.0)),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        labelText: 'Memo',
                                        labelStyle: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      maxLines: 10,
                                      minLines: 5,
                                      cursorColor: Colors.black,
                                      onSaved: (String? value) {
                                        editedPassword['memo'] = value;
                                      })),
                              editFlags['readOnly']
                                  ? Container()
                                  : Padding(
                                      padding: EdgeInsets.only(top: paddingTop),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.black,
                                          backgroundColor: const Color.fromARGB(
                                              255, 87, 180, 90),
                                        ),
                                        onPressed: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            formKey.currentState!.save();
                                            savePassword(editedPassword);
                                          }
                                        },
                                        child: const Text('Save'),
                                      )),
                            ]))))))));
  }
}
