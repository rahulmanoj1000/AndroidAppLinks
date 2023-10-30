// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:links/pages/Links/createLink.dart';
import 'package:links/pages/Links/previewLinks.dart';
import 'package:links/pages/Texts/createText.dart';
import 'package:links/pages/home.dart';
import 'package:links/pages/Texts/previewText.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Home(),
      '/crtext': (context) => CrText(),
      '/crlink': (context) => CrLink(),
      '/prtext': (context) => PreviewText(),
      '/prlink': (context) => PreviewLink()
    },
  ));
}
