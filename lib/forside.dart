import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data.dart';

class Forside extends StatefulWidget {
  @override
  ForsideState createState() => ForsideState();
}

class ForsideState extends State<Forside> {
  String result = "";
  DatabaseEjer db = DatabaseEjer.instans;
  Future<List<MadVare>> madVarer;

  @override
  void initState() {
    super.initState();
    madVarer = db.alleMadVarer();
  }

  @override
  void setState(fn) {
    super.setState(fn);
    madVarer = db.alleMadVarer();
  }

  void _scan() async {
    try {
      String scanResult = await BarcodeScanner.scan();
      setState(() {
        result = scanResult;
      });
    } on PlatformException catch (exception) {
      if (exception.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Appen har ikke adgang til kameraet";
        });
      } else {
        setState(() {
          result = "Ukendt fejl: $exception";
        });
      }
    } on FormatException {
      setState(() {
        result = "";
      });
    } catch (exception) {
      setState(() {
        result = "Ukendt fejl: $exception";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Varer"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.sort),
            tooltip: "Sortér",
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<List<MadVare>>(
        future: madVarer,
        initialData: List<MadVare>(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, position) {
                return FutureBuilder(
                  future: snapshot.data[position].findType(),
                  initialData: MadType(),
                  builder: (BuildContext _context, AsyncSnapshot _snapshot) {
                    return Card(
                      child: ListTile(
                        title: Text("${_snapshot.data.navn}"),
                        subtitle: Text("${_snapshot.data.kategori}"),
                        trailing: Text("Udløber om ${snapshot.data[position].dageTilbage()} dage."),
                        onTap: () {},
                      ),
                    );
                  }
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton.extended(
            heroTag: null,
            label: Text("Scan "),
            icon: Icon(Icons.camera_enhance),
            onPressed: () {
              _scan();
            },
          ),
          Container(width: 13.0, height: 13.0),
          FloatingActionButton.extended(
            heroTag: null,
            label: Text("Tilføj"),
            icon: Icon(Icons.add),
            onPressed: () {
              _tilfoejOgRefresh(context);
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

  _tilfoejOgRefresh(BuildContext context) async {
    await Navigator.pushNamed(context, '/tilfoej');
    setState((){});
  }
}