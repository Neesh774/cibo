import 'package:flutter/material.dart';

class DropDownButton extends StatefulWidget {
  @override
  _DropDownButtonState createState() => _DropDownButtonState();
}

class _DropDownButtonState extends State<DropDownButton> {
  //Your String used for defining the selection**
  String _currentSelection = "Wednesday";

  //Your build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("DropDownSample"),
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 30.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text('Remind me every '),
                  DropdownButton<String>(
                    //Don't forget to pass your variable to the current value
                    value: _currentSelection,
                    items: <String>[
                      'Sunday',
                      'Monday',
                      'Tuesday',
                      'Wednesday',
                      'Thursday',
                      'Friday',
                      'Saturday'
                    ].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    //On changed update the variable name and don't forgot the set state!
                    onChanged: (newValue) {
                      setState(() {
                        _currentSelection = newValue;
                      });
                    },
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
