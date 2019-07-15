import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CheckinPage extends StatefulWidget {
  static const String routeName = "/check-in";
  @override
  _ScanState createState() => new _ScanState();
}

class _ScanState extends State<CheckinPage> {
  String barcode = "";

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('eeeee111111111111111111111111111111111111111111111111111111111111111111111111111');
    return Scaffold(
        appBar: new AppBar(
          title: new Text('QR Code Scanner'),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    splashColor: Colors.blueGrey,
                    onPressed: scan,
                    child: const Text('START CAMERA SCAN')
                ),
              )
              ,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(barcode, textAlign: TextAlign.center,),
              )
              ,
            ],
          ),
        ));
  }

  Future scan() async {
    debugPrint('eeeee111111111111111111111111111111111111111111111111111111111111111111111111111');
    try {
      String barcode = await BarcodeScanner.scan();
      print('aaaaa111111111111111111111111111111111111111111111111111111111111111111111111111');
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      print('cccccc111111111111111111111111111111111111111111111111111111111111111111111111111');
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException{
      print('bbbbbb111111111111111111111111111111111111111111111111111111111111111111111111111');
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      print('dddddd111111111111111111111111111111111111111111111111111111111111111111111111111');
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}