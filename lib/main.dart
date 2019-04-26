import 'dart:async';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false, 
  home: HomePage(),
));

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String result = "Wowie!";

  Future _scanQR() async {
    try {
      String scanResult = await BarcodeScanner.scan();
       setState(() {
         result = scanResult;
       });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Kunne ikke få adgang til kameraet";
        });
      } else {
        setState(() {
          result = "Ukendt fejl $e"; 
        });
      }
    } on FormatException {
      setState(() {
        result = "Du trykkede tilbage uden at scanne noget";
      });
    } catch (e) {
      setState(() {
        result = "Ukendt fejl $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stregkode scanner"),
      ),
      body: Center(
        child: Text(
          "Scan that shit",
          style: new TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Text("Læs stregkode på vare"),
        onPressed: _scanQR,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}