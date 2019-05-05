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
  String sortering = "Alfabetisk";

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Varer"),
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.sort),
          //   onPressed: () {
          //     showDialog(
          //       context: context,
          //       builder: (BuildContext context) {
          //         return AlertDialog(
          //           title: Text("Sortering"),
          //           content: new ListView(
          //             children: <Widget>[
          //               DropdownButton<String>(
          //                 value: sortering,
          //                 onChanged: (String nySortering) {
          //                   setState(() {
          //                     sortering = nySortering;
          //                   });
          //                 },
          //                 items: <String>["Alfabetisk", "Udløbsdato"].map((String valgt) {
          //                   return DropdownMenuItem<String>(
          //                     value: valgt,
          //                     child: Text(valgt),
          //                   );
          //                 }).toList(),
          //               ),
          //             ],
          //           ),
          //         );
          //       }
          //     );
          //   },
          // ),
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
                return new Dismissible(
                  key: Key(snapshot.data[position].id.toString()),
                  onDismissed: (direction) => _swipeMadVare(context, direction, snapshot.data[position].id),
                  background: Container(
                    padding: EdgeInsets.only(left: 20.0),
                    color: Colors.amberAccent, 
                    child: new Align(
                      child: Text(
                        "Rediger",
                        textAlign: TextAlign.right,
                        style: new TextStyle(color: Colors.white),
                        textScaleFactor: 1.2,
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  secondaryBackground: Container(
                    padding: EdgeInsets.only(right: 20.0),
                    color: Colors.redAccent, 
                    child: new Align(
                      child: Text(
                        "Slet",
                        textAlign: TextAlign.left,
                        style: new TextStyle(color: Colors.white),
                        textScaleFactor: 1.2,
                      ),
                      alignment: Alignment.centerRight,
                    ),
                  ),
                  child: FutureBuilder(
                    future: snapshot.data[position].findType(),
                    initialData: MadType(),
                    builder: (BuildContext _context, AsyncSnapshot _snapshot) {
                      return Card(
                        child: ListTile(
                          leading: Container(
                            child: CircleAvatar(
                              child: Text(
                                "${snapshot.data[position].antal}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          title: Text("${_snapshot.data.navn}"),
                          subtitle: Text("${_snapshot.data.kategori}"),
                          trailing: Text("Mht. om ${snapshot.data[position].dageTilbage()} dage."),
                          onTap: () {},
                        ),
                      );
                    }
                  ),
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
          // FloatingActionButton.extended(
          //   heroTag: null,
          //   label: Text("Scan "),
          //   icon: Icon(Icons.camera_enhance),
          //   onPressed: () {
          //     _scan();
          //   },
          // ),
          // Container(width: 13.0, height: 13.0),
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
              child: Text(""),
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

  _swipeMadVare(BuildContext context, DismissDirection direction, int id) async {
    if (direction == DismissDirection.endToStart) {
      MadVare madVare = await db.findMadVare(id);
      db.sletMadVare(id);

      List<MadVare> madVareListe = await db.alleMadVarer();
      if (madVareListe.length <= 0) {
        setState(() {});
      }

      Scaffold.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 5),
          content: Text("Slettede madvare"),
          action: SnackBarAction(
            label: "Fortryd",
            onPressed: () {
              db.indsaetMadVare(madVare);
              setState(() {});
            },
          ),
        ),
      );
    } else if (direction == DismissDirection.startToEnd) {
      MadVare madVare = await db.findMadVare(id);

      final cancel = await Navigator.of(context).pushNamed('/tilfoej', arguments: madVare);

      if (!cancel) {
        await db.sletMadVare(id);
        setState(() {});
      } else {
        setState(() {});
      }
    }
  }

  _scan() async {
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
}