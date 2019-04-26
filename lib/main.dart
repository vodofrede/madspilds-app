import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false, 
  home: HomePage(),
));

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stregkode scanner"),
      ),
      body: Center(
        child: Text(
          "Scan that shit",
          style: new TextStyle(fontSize: 40.0),
        ),
      ),
    );
  }
}