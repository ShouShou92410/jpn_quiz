import 'package:flutter/material.dart';

import '../enumerations.dart';

class MyRouteInformationParser extends RouteInformationParser<MyRoutes> {
  @override
  Future<MyRoutes> parseRouteInformation(RouteInformation routeInformation) async {
    switch (routeInformation.location) {
      case "/quiz":
        return MyRoutes.quiz;
        break;
      case "/about":
        return MyRoutes.about;
        break;
      default:
        return MyRoutes.home;
    }
  }
  
  @override
  RouteInformation restoreRouteInformation(MyRoutes configuration) {
    switch (configuration) {
      case MyRoutes.quiz:
        return RouteInformation(location: '/quiz');
        break;
      case MyRoutes.about:
        return RouteInformation(location: '/about');
        break;
      default:
        return RouteInformation(location: '/');
    }
  }
}