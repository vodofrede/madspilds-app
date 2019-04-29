import 'package:flutter/material.dart';

void main() => runApp(MadApp());

class MadApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
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
          child: MadListe(),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text("Madspilds app", ),
                decoration: BoxDecoration(
                  color: Colors.blue
                ),
              ),
              ListTile(
                title: Text("Varer"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Indstillinger"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
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
    return Text("Hackerman got you HACKED!!! CUNT");
  }
}

