import 'package:flutter/material.dart';
import 'package:links/database/database_helper.dart';
import 'package:links/services/text_format.dart';

class CrLink extends StatefulWidget {
  CrLink({super.key});
  Map receivedData = {};

  @override
  State<CrLink> createState() => _CrLinkState();
}

class _CrLinkState extends State<CrLink> {
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
        String title = receivedData['links_name'];
        String body = receivedData['link'];
        int? ID = receivedData['links_id'];

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
                  border: UnderlineInputBorder(),
                  labelText: 'Enter a Label that you want to save link by'),
            ),
            const SizedBox(height: 50),
            TextFormField(
              controller: contentController,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter the link you want to save'),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 150),
              ),
              onPressed: () async {
                if (isDataReceived == false) {
                  await DatabaseHelper.instance.insertLink({
                    DatabaseHelper.linksName: titleController.text,
                    DatabaseHelper.link: contentController.text,
                  });
                  Navigator.pop(context);
                } else {
                  await DatabaseHelper.instance.updateLink({
                    DatabaseHelper.linksId: id,
                    DatabaseHelper.linksName: titleController.text,
                    DatabaseHelper.link: contentController.text,
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
