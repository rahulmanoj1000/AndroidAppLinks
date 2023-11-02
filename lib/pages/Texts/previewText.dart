import 'package:flutter/material.dart';
import 'package:links/database/database_helper.dart';
import 'package:links/services/color_priority.dart';
import 'package:sqflite/sqflite.dart';

class PreviewText extends StatefulWidget {
  const PreviewText({super.key});

  @override
  State<PreviewText> createState() => _PreviewTextState();
}

class _PreviewTextState extends State<PreviewText> {
  late List<Map<String, dynamic>> x = [];
  ColorPriority colorPriority = ColorPriority();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    List<Map<String, dynamic>> data = await dbData();
    setState(() {
      x = data;
    });
  }

  Future<List<Map<String, dynamic>>> dbData() async {
    Database db = await DatabaseHelper.instance.database;
    return await db.query('myTable');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Texts'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/crtext');
          fetchData();
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: x.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(
                  color: colorPriority.colour(x[index]['textPriority']) ??
                      Colors.white, // Border color
                  width: 4.0, // Border width
                ),
              ),
              child: Card(
                margin: EdgeInsets.zero,
                child: Dismissible(
                  key: Key(
                      x[index]['_id'].toString()), // Unique key for each item
                  onDismissed: (direction) async {
                    // Handle the swipe action (e.g., delete the item)
                    await DatabaseHelper.instance.delete(x[index]['_id']);

                    setState(() {
                      x = List.from(x); // Make a mutable copy of the list
                      x.removeAt(index); // Remove the item from the copy
                    });
                  },
                  background: Container(
                    color: Colors.red, // Background color for swipe action
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    onTap: () async {
                      // Handle the regular tap action, if needed
                      await Navigator.pushNamed(context, '/crtext', arguments: {
                        '_id': x[index]['_id'],
                        'title': x[index]['title'],
                        'body': x[index]['body'],
                        'textPriority': x[index]['textPriority'],
                      });
                      fetchData();
                    },
                    title: Text(
                      x[index]['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
