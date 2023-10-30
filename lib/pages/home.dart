// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/38596.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.7), BlendMode.dstATop)),
        ),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/prtext');
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: const Text(
                  'Texts',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.fromLTRB(
                    40, 10, 40, 10), // Replace with the desired color
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/prlink');
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: const Text(
                  'Links',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
