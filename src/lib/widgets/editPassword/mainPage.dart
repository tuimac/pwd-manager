// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:src/services/data_file_io.dart';
import 'package:src/utils/generate_password.dart';

class EditPassword extends StatefulWidget {
  final String primaryKey;
  final Map<String, dynamic> data;
  const EditPassword({super.key, required this.primaryKey, required this.data});

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
  late String randomPasswordSuggestion = "";
  final ValueNotifier<String> suggestionNotifier = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    data = widget.data;
    primaryKey = widget.primaryKey;
    passwordVisible = true;
  }

  @override
  void dispose() {
    suggestionNotifier.dispose();
    super.dispose();
  }

  void savePassword(Map<String, dynamic> editedPassword) {
    setState(() {
      editedPassword['modify_timestamp'] = DateTime.now().toIso8601String();
      data[primaryKey] = editedPassword;
      DataFileIO.saveData(data).then((value) => GoRouter.of(context).pop());
    });
  }

  void copyToClipboard(String clipboardText) {
    Clipboard.setData(ClipboardData(text: clipboardText));
  }

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
                              // Password Name section
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
                                        return '"Password Name" is empty.';
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
                              // User Name section
                              Padding(
                                  padding: EdgeInsets.only(top: paddingTop),
                                  child: TextFormField(
                                    onTap: () {
                                      if (editFlags['readOnly']!) {
                                        copyToClipboard(
                                            data[primaryKey]['username']);
                                      }
                                    },
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
                              // Password section
                              Padding(
                                  padding: EdgeInsets.only(top: paddingTop),
                                  child: Autocomplete<String>(
                                      optionsBuilder: (TextEditingValue
                                          textEditingValue) async {
                                        suggestionNotifier.value =
                                            await GeneratePassword
                                                .genPassword();

                                        if (textEditingValue.text.isEmpty) {
                                          return [randomPasswordSuggestion];
                                        }
                                        return const Iterable<String>.empty();
                                      },
                                      initialValue: TextEditingValue(
                                        text:
                                            data[primaryKey]['password'] ?? '',
                                      ),
                                      onSelected: (String selectedValue) {
                                        // The selected password will be inserted automatically
                                        // into the TextFormField by Autocomplete.
                                      },
                                      optionsViewBuilder: (
                                        BuildContext context,
                                        AutocompleteOnSelected<String>
                                            onSelected,
                                        Iterable<String> options,
                                      ) {
                                        return Align(
                                          alignment: Alignment.topLeft,
                                          child: Material(
                                            elevation: 4,
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              child: ListView.builder(
                                                padding: EdgeInsets.zero,
                                                shrinkWrap: true,
                                                itemCount: options.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return ListTile(
                                                    title:
                                                        ValueListenableBuilder<
                                                            String>(
                                                      valueListenable:
                                                          suggestionNotifier,
                                                      builder: (context,
                                                          suggestion, child) {
                                                        return Text(
                                                          suggestion,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .labelLarge,
                                                        );
                                                      },
                                                    ),
                                                    onTap: () {
                                                      onSelected(
                                                          suggestionNotifier
                                                              .value);
                                                    },
                                                    trailing: IconButton(
                                                      icon: const Icon(
                                                          Icons.refresh),
                                                      onPressed: () async {
                                                        suggestionNotifier
                                                                .value =
                                                            await GeneratePassword
                                                                .genPassword();
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      fieldViewBuilder: (
                                        BuildContext context,
                                        TextEditingController
                                            textEditingController,
                                        FocusNode focusNode,
                                        VoidCallback onFieldSubmitted,
                                      ) {
                                        return TextFormField(
                                            onTap: () {
                                              if (editFlags['readOnly']!) {
                                                copyToClipboard(data[primaryKey]
                                                    ['password']);
                                              }
                                            },
                                            readOnly: editFlags['readOnly']!,
                                            style:
                                                TextStyle(fontSize: textSize),
                                            textInputAction:
                                                TextInputAction.next,
                                            obscureText: passwordVisible,
                                            focusNode: focusNode,
                                            controller: textEditingController,
                                            keyboardType: TextInputType.text,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            decoration: InputDecoration(
                                                filled: true,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                  vertical:
                                                      contentPadding['y']!,
                                                  horizontal:
                                                      contentPadding['x']!,
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
                                                border:
                                                    const OutlineInputBorder(
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
                                                      data[primaryKey][
                                                              'watch_timestamp'] =
                                                          DateTime.now()
                                                              .toIso8601String();
                                                    });
                                                  },
                                                )),
                                            cursorColor: Colors.white,
                                            validator: (input) {
                                              if (input == null ||
                                                  input.isEmpty) {
                                                return '"Password" is empty.';
                                              } else {
                                                return null;
                                              }
                                            },
                                            onSaved: (String? value) {
                                              editedPassword['password'] =
                                                  value;
                                            });
                                      })),
                              // Memo section
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
                              // Edit button section
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
