import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() => runApp(RatelApp());

class RatelApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('RFlutter Alert by Ratel'),
        ),
        body: PopupDialog(),
      ),
    );
  }
}

class PopupDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: new Icon(Icons.account_circle),
              onPressed: () => _onBasicAlertPressed(context),
            ),
          ],
        ),
      ),
    );
  }

// The easiest way for creating RFlutter Alert
  _onBasicAlertPressed(context) {
    Alert(
            context: context,
            title: "RFLUTTER ALERT",
            desc: "Flutter is more awesome with RFlutter Alert.")
        .show();
  }
}
