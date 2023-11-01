import 'package:flutter/material.dart';
import 'package:links/database/database_helper.dart';
import 'package:links/services/color_priority.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';

class PreviewLink extends StatefulWidget {
  const PreviewLink({super.key});

  @override
  State<PreviewLink> createState() => _PreviewLinkState();
}

class _PreviewLinkState extends State<PreviewLink> {
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
    return await db.query('myLinks');
  }

  Future<void> _launchUrl(Uri url) async {
    try {
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      final snackBar = SnackBar(
        content: const Text('Invalid Link Stored Here!! Please modify!!'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Links'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/crlink');
          fetchData();
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
          itemCount: x.length,
          itemBuilder: (context, index) {
            return Card(
              child: Dismissible(
                key: Key(x[index]['links_id'].toString()),
                onDismissed: (direction) async {
                  await DatabaseHelper.instance
                      .deleteLink(x[index]['links_id']);
                  setState(() {
                    x = List.from(x); // Make a mutable copy of the list
                    x.removeAt(index); // Remove the item from the copy
                  });
                },
                background: Container(
                  color: Colors.red[900],
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                child: ListTile(
                  onTap: () async {
                    // Get the URL from the 'link' property in your data
                    Uri url = Uri.parse(x[index]['link']);

                    _launchUrl(url);
                  },
                  title: Row(
                    children: [
                      Container(
                        width: 50.0, // Adjust the width as needed
                        height: 40.0,
                        decoration: ShapeDecoration(
                          shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          color: colorPriority.colour(x[index]['linkPriority']),
                        ),
                        child: IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              // Handle the regular tap action, if needed
                              await Navigator.pushNamed(context, '/crlink',
                                  arguments: {
                                    'links_id': x[index]['links_id'],
                                    'links_name': x[index]['links_name'],
                                    'link': x[index]['link'],
                                    'linkPriority': x[index]['linkPriority'],
                                  });
                              fetchData();
                            }),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        x[index]['links_name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
