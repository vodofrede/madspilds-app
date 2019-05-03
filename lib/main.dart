import 'package:flutter/material.dart';

import 'forside.dart';
import 'tilfoej.dart';
import 'indstillinger.dart';

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
      },
    );
  }
}