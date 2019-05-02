import 'package:flutter/material.dart';

import 'varetype_data.dart';

class VareTypeListe extends StatelessWidget {
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

class _VareTypeGenstand extends ListTile {
  _VareTypeGenstand(VareType vareType): super(
    title: Text(vareType.vareNavn),
    subtitle: Text("Varer " + vareType.varighed + " dage"),
  );
}