import 'package:flutter/material.dart';
import 'package:links/database/database_helper.dart';
import 'package:links/services/color_priority.dart';
import 'package:links/services/text_format.dart';

class CrLink extends StatefulWidget {
  CrLink({super.key});
  Map receivedData = {};

  @override
  State<CrLink> createState() => _CrLinkState();
}

class _CrLinkState extends State<CrLink> {
  ColorPriority colorPriority = ColorPriority();
  String dropdownValue = 'Low Priority';
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final priorityController = TextEditingController();
  List<TextFormat> data = [];
  int id = 0;
  String title = "Create";
  Color linkPriorityColorG = Colors.white;
  String linkPriorityStringG = "";

  String getKeyByValue(Map<String, Color> map, Color value) {
    for (var entry in map.entries) {
      if (entry.value == value) {
        return entry.key;
      }
    }
    // If the value is not found, return a default or handle it as needed
    return "Key not found";
  }

  String colorToHex(Color color) {
    return color.toString();
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    priorityController.dispose();
    super.dispose();
  }

  bool isDataReceived = false;

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final receivedData = ModalRoute.of(context)!.settings.arguments;
      title = "Edit";
      if (receivedData is Map<String, dynamic>) {
        String title = receivedData['links_name'];
        String body = receivedData['link'];
        int? ID = receivedData['links_id'];

        if (ID != null) {
          id = ID;
        }
        if (!isDataReceived) {
          dropdownValue = receivedData['linkPriority'];
        }
        titleController.text = title;
        contentController.text = body;
      }
      isDataReceived = true;
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
                    linkPriorityColorG =
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
                      DatabaseHelper.linkPriority: dropdownValue,
                    });
                    Navigator.pop(context);
                  } else {
                    await DatabaseHelper.instance.updateLink({
                      DatabaseHelper.linksId: id,
                      DatabaseHelper.linksName: titleController.text,
                      DatabaseHelper.link: contentController.text,
                      DatabaseHelper.linkPriority: dropdownValue,
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
