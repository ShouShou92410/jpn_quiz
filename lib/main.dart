import 'package:flutter/material.dart';

import 'route/MyRouteInformationParser.dart';
import 'route/MyRouterDelegate.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MyRouterDelegate _delegate = MyRouterDelegate();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'JPN Quiz',
      theme: ThemeData(
        primarySwatch: Colors.purple
      ),
      routeInformationParser: MyRouteInformationParser(), 
      routerDelegate: _delegate
    );
  }
}
