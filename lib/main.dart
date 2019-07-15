import 'package:flutter/material.dart';
import 'package:MLCheckinFlutter/screens/baomuon.dart';
import 'package:MLCheckinFlutter/screens/xinnghi.dart';

import 'dart:async';
import 'dart:convert';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() => runApp(
  new MaterialApp(
    title: "aaa",
    home: new MyHome(),
    routes: <String, WidgetBuilder>{
      BaoMuonPage.routeName: (BuildContext context) => new BaoMuonPage(),
      XinNghiPage.routeName: (BuildContext context) => new XinNghiPage(),
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

    Future<void> _neverSatisfied(text) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Lỗi'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(text),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Hủy'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    Future<Post> createPost({Map body}) async{
      final response = await http.post("https://dashboard.moneylover.me/checkin/add", body: body);
      return Post.fromJson(json.decode(response.body));
    }

    try {
      String barcode = await BarcodeScanner.scan();
      Post post = Post(
          memberKey: "5a40b12cd1851e4fa8a4cf81",
          qrcode: barcode
      );
      await createPost(body: post.toMap());
      _neverSatisfied('Send Success');
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        _neverSatisfied('The user did not grant the camera permission!');
      } else {
        _neverSatisfied('Unknown error: $e');
      }
    } on FormatException{
      // _neverSatisfied('User returned using the "back"-button before scanning anything');
    } catch (e) {
      _neverSatisfied('Unknown error: $e');
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

class Post {
  final String memberKey;
  final String qrcode;

  Post({this.memberKey, this.qrcode});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      memberKey: json['memberKey'],
      qrcode: json['qrcode']
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["memberKey"] = memberKey;
    map["qrcode"] = qrcode;

    return map;
  }
}
