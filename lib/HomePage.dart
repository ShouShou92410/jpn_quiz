import 'package:flutter/material.dart';

import 'enumerations.dart';
import 'route/MyRouterDelegate.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget titleSection = Center(
      child: Container(
        margin: EdgeInsets.all(10),
        child: Text(
          'JPN Quiz',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold
          )
        )
      )
    );

    Widget buttonSection = Column(
      children:[
        _buildButton(context, 'Quiz', MyRoutes.quiz),
        _buildButton(context, 'About', MyRoutes.about)
      ]
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('JPN Quiz'),
      ),
      body: Row(
        children: [
          Expanded(flex: 2, child: Container()),
          Expanded(
            flex: 6, 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                titleSection,
                buttonSection
              ]
            )
          ),
          Expanded(flex: 2, child: Container())
        ],
      )
    );
  }
  
  Container _buildButton(BuildContext context, String label, MyRoutes route) {
    return Container(
      margin: EdgeInsets.all(10),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 20)
          ),
          onPressed: (){
            (Router.of(context).routerDelegate as MyRouterDelegate)
              .configuration = route;
          },
          child: Text(label),
        )
      )
    );
  }
}

