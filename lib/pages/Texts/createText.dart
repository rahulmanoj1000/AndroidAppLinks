import 'package:flutter/material.dart';
import 'package:links/database/database_helper.dart';
import 'package:links/services/color_priority.dart';
import 'package:links/services/text_format.dart';

class CrText extends StatefulWidget {
  const CrText({super.key});

  @override
  State<CrText> createState() => _CrTextState();
}

class _CrTextState extends State<CrText> {
  ColorPriority colorPriority = ColorPriority();
  String dropdownValue = 'Low Priority';

  Map receivedData = {};

  final titleController = TextEditingController();
  final contentController = TextEditingController();

  List<TextFormat> data = [];
  int id = 0;
  String title = "Create";
  Color textPriorityColorG = Colors.white;

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
        if (!isDataReceived) {
          dropdownValue = receivedData['textPriority'];
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 30, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: colorPriority.colour(
                      dropdownValue), // Replace 'Colors.red' with your desired background color
                  borderRadius:
                      BorderRadius.circular(5.0), // Adjust the radius as needed
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: dropdownValue,
                  icon: const Icon(
                    Icons.arrow_downward,
                    color: Colors.black,
                  ),
                  elevation: 16,
                  style: const TextStyle(color: Colors.black),
                  // Set text color based on the selected key

                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    textPriorityColorG =
                        colorPriority.colour(dropdownValue) ?? Colors.white;
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                  items: colorPriority.colorMap.keys
                      .map<DropdownMenuItem<String>>((String key) {
                    return DropdownMenuItem<String>(
                      value: key,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(key),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(), labelText: 'Enter Title'),
              ),
              const SizedBox(height: 50),
              TextFormField(
                controller: contentController,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(), labelText: 'Enter Content'),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 150),
                ),
                onPressed: () async {
                  if (isDataReceived == false) {
                    await DatabaseHelper.instance.insert({
                      DatabaseHelper.columntitle: titleController.text,
                      DatabaseHelper.columnbody: contentController.text,
                      DatabaseHelper.textPriority: dropdownValue,
                    });
                    print(dropdownValue);
                    Navigator.pop(context);
                  } else {
                    await DatabaseHelper.instance.update({
                      DatabaseHelper.columnId: id,
                      DatabaseHelper.columntitle: titleController.text,
                      DatabaseHelper.columnbody: contentController.text,
                      DatabaseHelper.textPriority: dropdownValue,
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
