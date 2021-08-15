import 'package:borsawalletapp/Home/send_recieve.dart';
import 'package:borsawalletapp/LoginSignup/welcomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<Profile> {
  String handle = "@testhandle", name = "TestName", status = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
        child: Column(
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.blueGrey),
          child: Container(
            width: double.infinity,
            height: 150,
            child: Container(
              alignment: Alignment(0.0, 2.5),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://media-exp1.licdn.com/dms/image/C4E03AQGslxjziwPa-g/profile-displayphoto-shrink_800_800/0/1554201528216?e=1634169600&v=beta&t=PiJsOwLTSAkVMDQWwuwcpDKd3R5adRPNpN5s8FNdm90"),
                radius: 60.0,
                backgroundColor: Color(0xffBBDEFB),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 50,
        ),
        FutureBuilder(
            future: getHandleAndName(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.data) {
                return profileData();
              } else {
                clearSP();
                return CircularProgressIndicator();
              }
            }),
        SizedBox(
          height: 15,
        ),
        ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            Card(
              child: ListTile(
                  title: Text("Settings"),
                  subtitle: Text("Settings and preferences about app"),
                  leading: Icon(Icons.settings)),
            ),
            Card(
              child: ListTile(
                  title: Text("Deposit"),
                  subtitle: Text("Deposit Funds on BorsaApp"),
                  leading: Icon(Icons.monetization_on)),
            ),
            Card(
              child: ListTile(
                  title: Text("Withdraw"),
                  subtitle: Text("Withdraw funds from BorsaApp"),
                  leading: Icon(Icons.send)),
            ),
          ],
        ),
        InkWell(
          onTap: () {
            clearSP();
          },
          child: Card(
              margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              elevation: 2.0,
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  child: Text(
                    "Logout",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ))),
        ),
      ],
    ));
  }

  Future<void> clearSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => WelcomePage()));
  }

  Future<bool> getHandleAndName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    handle = prefs.getString("username");
    name = prefs.getString("name");
    status = prefs.getString("status");

    return handle.isNotEmpty;
  }

  profileData() {
    return Column(
      children: [
        Text(
          name,
          style: TextStyle(
              fontSize: 25.0,
              color: Colors.blueGrey,
              fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 5,
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(
              text: '@',
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
            TextSpan(
              text: handle,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
          ]),
        ),
        SizedBox(
          height: 15,
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(
              text: 'Status: ',
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
            TextSpan(
              text: status.toUpperCase(),
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ]),
        ),
      ],
    );
  }
}

class MyColor extends MaterialStateColor {
  const MyColor() : super(_defaultColor);

  static const int _defaultColor = 0xcafefeed;
  static const int _pressedColor = 0xff455A64;

  @override
  Color resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.pressed)) {
      return const Color(_pressedColor);
    }
    return const Color(_defaultColor);
  }
}
