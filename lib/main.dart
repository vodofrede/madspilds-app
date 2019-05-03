import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'forside.dart';
import 'tilfoej.dart';
import 'indstillinger.dart';
import 'stregkodescan.dart';
import 'data.dart';

void main() async {
  runApp(Varer());
}

class Varer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Madspild',
      theme: new ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: Forside(),
      routes: <String, WidgetBuilder> {
        '/forside': (BuildContext context) => new Forside(),
        '/tilfoej': (BuildContext context) => new Tilfoej(),
        '/indstillinger': (BuildContext context) => new Indstillinger(),
        '/stregkodescanner': (BuildContext context) => new StregkodeScanner(),
      },
    );
  }
}