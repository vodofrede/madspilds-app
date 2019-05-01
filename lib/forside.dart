import 'package:flutter/material.dart';

class Forside extends StatefulWidget {
  @override
  ForsideState createState() => ForsideState();
}

class ForsideState extends State<Forside> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Varer"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.sort),
            tooltip: "Sortér",
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Text("Madliste"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: null,
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed('/varetyper');
            },
          ),
          Container(width: 13.0, height: 13.0),
          FloatingActionButton(
            heroTag: null,
            child: Icon(Icons.camera_alt),
            onPressed: () {
              Navigator.of(context).pushNamed('/stregkodescanner');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text("Madspilds app"),
              decoration: BoxDecoration(
                color: Colors.lightBlue
              ),
            ),
            ListTile(
              title: Text("Varer"),
              leading: new Icon(Icons.fastfood),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Indstillinger"),
              leading: new Icon(Icons.settings),
              onTap: () {
                Navigator.of(context).pushNamed('/indstillinger');
              },
            ),
          ],
        ),
      ),
    );
  }
}
