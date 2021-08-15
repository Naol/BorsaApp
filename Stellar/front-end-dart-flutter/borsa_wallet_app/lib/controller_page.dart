import 'package:borsawalletapp/Home/activities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Assets/assets_screen.dart';
import 'Explore/explore_screen.dart';
import 'Home/home_screen.dart';
import 'Profile/profile_screen.dart';

class ControllerPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MyHomePage(title: 'Borsa Controller Page');
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [Home(), Explore(), Assets(), Profile()];

  String data = '';
  void onTabTapped(int index) {
    setState(() {
      print(index);
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: new IconButton(
          tooltip: "QR Code",
          icon: Icon(Icons.qr_code, color: Color(0xff455A64)),
          onPressed: () {
            setState(() {
              _showMyDialog();
            });
          },
        ),
        shadowColor: Color(0xff455A64),
        actions: [
          IconButton(
            tooltip: "Transactions",
            icon: Icon(Icons.assignment, color: Color(0xff455A64)),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ActivityPage()));
            },
          )
        ],
      ),
      body: _children[_currentIndex], // new

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.blueGrey,
        showUnselectedLabels: true,
        onTap: (value) => onTabTapped(value),
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.swap_horiz),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.account_balance_wallet),
            label: 'My Assets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          )
        ],
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Show this to pay'),
          content: SingleChildScrollView(
            child: FutureBuilder(
              initialData: "loading ID",
              future: getId(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error please restart"),
                  );
                } else if (snapshot.hasData) {
                  return ListBody(children: <Widget>[
                    Center(
                      child: Container(
                        width: 200.0,
                        height: 200.0,
                        child: QrImage(
                          data: snapshot.data,
                          version: QrVersions.auto,
                          size: 320,
                        ),
                      ),
                    ),
                    Center(child: Text('Profile ID -' + snapshot.data))
                  ]);
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Back'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> getId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    return {
      'id': sp.getInt("id"),
      "username": sp.getString("username"),
      "pno": sp.getString("pno")
    }.toString();
  }
}

class PlaceholderWidget extends StatelessWidget {
  final Color color;

  PlaceholderWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}
