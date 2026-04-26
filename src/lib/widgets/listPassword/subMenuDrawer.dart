import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ignore: must_be_immutable
class SubMenuDrawer extends StatefulWidget {
  final Map<String, dynamic> data;
  Function getData;
  SubMenuDrawer({Key? key, required this.data, required this.getData})
      : super(key: key);

  @override
  State<SubMenuDrawer> createState() => _SubMenuDrawerState();
}

class _SubMenuDrawerState extends State<SubMenuDrawer> {
  late Map<String, dynamic> data;
  late String primaryKey;
  late bool deleteConfirm = false;

  @override
  void initState() {
    super.initState();
    data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    Size uiSize = MediaQuery.of(context).size;
    double uiHeight = uiSize.height;
    double uiWidth = uiSize.width;
    FocusScope.of(context).unfocus();

    return Theme(
        data: Theme.of(context).copyWith(
          canvasColor: const Color.fromARGB(255, 196, 228, 232),
        ),
        child: Drawer(
            width: uiWidth * 0.6,
            backgroundColor: const Color.fromARGB(255, 173, 218, 232),
            child: ListView(padding: EdgeInsets.zero, children: [
              SizedBox(
                height: uiHeight * 0.12,
                child: const DrawerHeader(
                  child: Center(
                      child: Text('Sub Menu',
                          style: TextStyle(fontSize: 15, color: Colors.black))),
                ),
              ),
              Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 134, 179, 185),
                  ),
                  child: ListTile(
                    title: const Text('Home'),
                    onTap: () {
                      GoRouter.of(context).pop();
                    },
                  )),
              const Divider(height: 1, color: Colors.black),
              Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 134, 179, 185),
                  ),
                  child: ListTile(
                    title: const Text('Setting'),
                    onTap: () {
                      GoRouter.of(context).pop();
                      GoRouter.of(context)
                          .push('/systemconfig')
                          .then((value) => widget.getData());
                    },
                  )),
              const Divider(height: 1, color: Colors.black),
              Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 134, 179, 185),
                  ),
                  child: ListTile(
                    title: const Text('Restore'),
                    onTap: () {
                      GoRouter.of(context).pop();
                      GoRouter.of(context)
                          .push('/restore')
                          .then((value) => widget.getData());
                    },
                  )),
              const Divider(height: 1, color: Colors.black),
              Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 134, 179, 185),
                  ),
                  child: ListTile(
                    title: const Text('Import/Export'),
                    onTap: () {
                      GoRouter.of(context).pop();
                      GoRouter.of(context)
                          .push('/importexport', extra: data)
                          .then((value) {
                        widget.getData();
                      });
                    },
                  )),
              const Divider(height: 1, color: Colors.black),
              Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 134, 179, 185),
                  ),
                  child: ListTile(
                    title: const Text('System Log'),
                    onTap: () {
                      GoRouter.of(context).pop();
                      GoRouter.of(context).push('/systemlogs');
                    },
                  ))
            ])));
  }
}
