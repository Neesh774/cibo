import 'package:flutter/material.dart';
import 'package:cibo/widget/drawer.dart';
//C:\Users\kkanc\AndroidStudioProjects\cibo\cibo

class StoresPage extends StatelessWidget {
  static const String routeName = '/local_stores';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(

            title: Text("Local Grocery Stores")
        ),
        drawer: AppDrawer(),
        body: Center(child: Text("Stores")));
  }
}
