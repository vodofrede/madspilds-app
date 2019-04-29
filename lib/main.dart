import 'package:flutter/material.dart';
// import 'package:barcode_scan/barcode_scan.dart';

void main() => runApp(MadApp());

class MadApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter'),
        ),
        body: Center(
          child: MadListe(),
        ),
      ),
    );
  }
}

class MadListe extends StatefulWidget {
  @override
  MadListeState createState() => MadListeState();
}

class MadListeState extends State<MadListe> {
  @override
  Widget build(BuildContext build) {
    return Text("Hackerman got you HACKED!!! BITCH");
  }
}