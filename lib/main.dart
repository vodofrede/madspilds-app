import 'package:flutter/material.dart';

import 'forside.dart';
import 'varetyper.dart';
import 'indstillinger.dart';
import 'stregkodescan.dart';

void main() => runApp(Varer());

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
        '/varetyper': (BuildContext context) => new VareTypeListe(),
        '/indstillinger': (BuildContext context) => new Indstillinger(),
        '/stregkodescanner': (BuildContext context) => new StregkodeScanner(),
      },
    );
  }
}