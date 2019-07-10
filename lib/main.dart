import 'package:flutter/material.dart';
import 'package:flutter_app/screens/baomuon.dart';
import 'package:flutter_app/screens/xinnghi.dart';
import 'package:flutter_app/screens/checkin.dart';

import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

void main() => runApp(
  new MaterialApp(
    title: "aaa",
    home: new MyHome(),
    routes: <String, WidgetBuilder>{
      BaoMuonPage.routeName: (BuildContext context) => new BaoMuonPage(),
      XinNghiPage.routeName: (BuildContext context) => new XinNghiPage(),
      CheckinPage.routeName: (BuildContext context) => new CheckinPage(),
    },
  )
);

class MyHome extends StatefulWidget {
  @override
  MyHomeState createState() => new MyHomeState();
}

class MyHomeState extends State<MyHome> with SingleTickerProviderStateMixin {
  TabController controller;
  PageController pageController;
  int currentIndex = 0;
  String barcode = "";

  @override
  void initState() {
    super.initState();
    pageController = new PageController(
        initialPage: currentIndex,
        keepPage: true
    );

//    controller = new TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
//    controller.dispose();
    pageController.dispose();
    super.dispose();
  }

  pageChanged(int page){
    setState(() {
      currentIndex = page;
    });
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  Widget build(BuildContext context) {

    void _onTap(int index) {
      if (index == 0) {
        Navigator.of(context).pushNamed('/bao-muon');
      }
      if (index == 1) {
        this.scan();
      }
      if (index == 2) {
        Navigator.of(context).pushNamed('/xin-nghi');
      }
    }

    return MaterialApp(
      title: 'ML Checkin',
      home: Scaffold(

        appBar: AppBar(
          title: Text('MoneyLover Checkin'),
        ),

        body: new Container(
          child: new Center(
            child: new PageView(
              controller: pageController,
              onPageChanged: pageChanged,
              children: <Widget>[
                new RaisedButton(
                  child: new Text(
                    "Press me"
                  ),
                  color: Colors.red,
                  onPressed: () {
                    Navigator.of(context).pushNamed('/about');
                  },
                ),
                new BaoMuonPage(),
                new CheckinPage(),
                new XinNghiPage()
              ],
            ),
          ),
        ),

        bottomNavigationBar: new BottomNavigationBar(
          onTap: _onTap,
          type: BottomNavigationBarType.fixed,
          iconSize: 24.0,
          items: [
            new BottomNavigationBarItem(
              title: new Text('Báo muộn'),
              icon: new Icon(Icons.camera_alt, size: 0)
            ),
            new BottomNavigationBarItem(
                title: new Text('Báo muộn', style: new TextStyle(fontSize: 0)),
              icon: new Icon(Icons.camera_alt)
            ),
            new BottomNavigationBarItem(
              title: new Text('Xin nghỉ'),
              icon: new Icon(Icons.camera_alt, size: 0)
            ),
          ],
        ),
      ),
      theme: new ThemeData(primarySwatch: Colors.green),
    );
  }
}
