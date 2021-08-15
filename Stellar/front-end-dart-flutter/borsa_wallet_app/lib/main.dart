import 'package:borsawalletapp/controller_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LoginSignup/welcomePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget page = WelcomePage();

  @override
  void initState() {
    checkLoggedIn().then((value) {
      if (value) {
        page = ControllerPage();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    Map<int, Color> colorCodes = {
      50: Color.fromRGBO(147, 205, 72, .1),
      100: Color.fromRGBO(147, 205, 72, .2),
      200: Color.fromRGBO(147, 205, 72, .3),
      300: Color.fromRGBO(147, 205, 72, .4),
      400: Color.fromRGBO(147, 205, 72, .5),
      500: Color.fromRGBO(147, 205, 72, .6),
      600: Color.fromRGBO(147, 205, 72, .7),
      700: Color.fromRGBO(147, 205, 72, .8),
      800: Color.fromRGBO(147, 205, 72, .9),
      900: Color.fromRGBO(147, 205, 72, 1),
    };

    MaterialColor color = new MaterialColor(0xff455A64, colorCodes);

    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: color,
        ),
        debugShowCheckedModeBanner: false,
        home: page);
  }

  Future<bool> checkLoggedIn() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("username").isNotEmpty;
  }
}
