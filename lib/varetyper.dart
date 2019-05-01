import 'package:flutter/material.dart';

class VareTyper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Madvarer"),
      ),
      body: Center(
        child: RaisedButton(
          child: Text("Tilbage til madlisten"),
          onPressed: () {
            Navigator.of(context).pop(context);
          },
        ),
      ),
    );
  }
}