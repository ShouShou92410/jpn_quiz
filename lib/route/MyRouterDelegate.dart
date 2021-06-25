import 'package:flutter/material.dart';

import '../AboutPage.dart';
import '../HomePage.dart';
import '../quiz/QuizPage.dart';
import 'MyRoutes.dart';

class MyRouterDelegate extends RouterDelegate<MyRoutes> 
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<MyRoutes> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  MyRoutes get configuration => _configuration;
  MyRoutes _configuration;
  set configuration(MyRoutes value) {
    if (_configuration == value) return;
    _configuration = value;
    notifyListeners();
  }

  @override
  Future<void> setNewRoutePath(MyRoutes configuration) async {
    _configuration = configuration;
  }

  @override
  MyRoutes get currentConfiguration => configuration;
  
  bool _handlePopPage(Route<dynamic> route, dynamic result) {
    final bool success = route.didPop(result);
    if (success) {
      _configuration = MyRoutes.home;
      notifyListeners();
    }
    return success;
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(key: ValueKey(''), child: HomePage()),
        if (configuration == MyRoutes.quiz)
          MaterialPage(key: ValueKey('quiz'), child: QuizPage()),
        if (configuration == MyRoutes.about)
          MaterialPage(key: ValueKey('about'), child: AboutPage()),
      ],
      onPopPage: _handlePopPage,
    );
  }
}