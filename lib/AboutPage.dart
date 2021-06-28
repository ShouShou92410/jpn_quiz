import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 
                  "This is app is powered by Jisho.org and uses it's public api to access Japanese vocabularies in different categories.\n"
                  "To see the source code ",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  height: 1.5
                )
              ),
              TextSpan(
                text: "Click here",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 15,
                  height: 1.5
                ),
                recognizer: TapGestureRecognizer()..onTap = () async {
                  String url = "https://github.com/ShouShou92410/jpn_quiz";
                  if (await canLaunch(url)) {
                    await launch(url);
                  }
                }
              )
            ]
          ),
        )
      )
    );
  }
}