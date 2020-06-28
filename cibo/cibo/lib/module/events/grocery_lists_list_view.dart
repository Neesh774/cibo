import 'package:flutter/material.dart';
import 'package:cibo/widget/drawer.dart';
//C:\Users\kkanc\AndroidStudioProjects\cibo\cibo

class ListsPage extends StatelessWidget {
  var groceryListNames = ["BJ's", "Indian store"];
  var numGroceryList = 2;
  static const String routeName = '/grocery_lists';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(title: Text("Grocery Lists")),
        drawer: AppDrawer(),
        body: new ListView(
          padding: const EdgeInsets.all(8.0),
          children: <Widget>[for (var item in list) Text(item)],
        ));
  }
}
