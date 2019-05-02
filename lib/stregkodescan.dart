import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

class StregkodeScanner extends StatefulWidget {
  @override
  _StregkodeScannerState createState() => _StregkodeScannerState();
}

class _StregkodeScannerState extends State<StregkodeScanner> {
  String result = "";

  Future _scan() async {
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
      body: Center(child: Text(result)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera),
        onPressed: _scan,
      ),
    );
  }
}