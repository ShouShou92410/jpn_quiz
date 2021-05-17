import 'package:flutter/material.dart';

import 'MyRoutes.dart';

class MyRouteInformationParser extends RouteInformationParser<MyRoutes> {
  @override
  Future<MyRoutes> parseRouteInformation(RouteInformation routeInformation) async {
    switch (routeInformation.location) {
      case "/quiz":
        return MyRoutes.quiz;
        break;
      case "/vocabularies":
        return MyRoutes.vocabularies;
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
      case MyRoutes.vocabularies:
        return RouteInformation(location: '/vocabularies');
        break;
      case MyRoutes.about:
        return RouteInformation(location: '/about');
        break;
      default:
        return RouteInformation(location: '/');
    }
  }
}