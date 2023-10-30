// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:links/database/database_helper.dart';
import 'package:links/services/text_format.dart';

class CrText extends StatefulWidget {
  CrText({super.key});
  Map receivedData = {};
  @override
  State<CrText> createState() => _CrTextState();
}

class _CrTextState extends State<CrText> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  List<TextFormat> data = [];
  int id = 0;
  String title = "Create";

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  bool isDataReceived = false;

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final receivedData = ModalRoute.of(context)!.settings.arguments;
      isDataReceived = true;
      title = "Edit";
      if (receivedData is Map<String, dynamic>) {
        String title = receivedData['title'];
        String body = receivedData['body'];
        int? ID = receivedData['_id'];

        if (ID != null) {
          id = ID;
        }

        titleController.text = title;
        contentController.text = body;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('$title Text'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, top: 50, right: 20),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(), labelText: 'Enter Title'),
            ),
            SizedBox(height: 50),
            TextFormField(
              controller: contentController,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(), labelText: 'Enter Content'),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 150),
              ),
              onPressed: () async {
                if (isDataReceived == false) {
                  await DatabaseHelper.instance.insert({
                    DatabaseHelper.columntitle: titleController.text,
                    DatabaseHelper.columnbody: contentController.text,
                  });
                  Navigator.pop(context);
                } else {
                  await DatabaseHelper.instance.update({
                    DatabaseHelper.columnId: id,
                    DatabaseHelper.columntitle: titleController.text,
                    DatabaseHelper.columnbody: contentController.text,
                  });
                  Navigator.pop(context);
                }
              },
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
