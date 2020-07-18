import 'package:flutter/material.dart';
import 'package:cibo/routes/Routes.dart';

//C:\Users\kkanc\AndroidStudioProjects\cibo\cibo
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createDrawerItem(
              icon: Icons.fastfood,
              text: 'Recipes',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, Routes.recipes)),
          _createDrawerItem(
              icon: Icons.format_list_bulleted,
              text: 'My Grocery Lists',
              onTap: () => Navigator.pushReplacementNamed(
                  context, Routes.grocery_lists)),
          _createDrawerItem(
              icon: Icons.local_grocery_store,
              text: 'Local Grocery Stores',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, Routes.local_stores)),
        ],
      ),
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        child: Container(
            color: Colors.blueAccent[100],
            child: Stack(children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(15, 15, 300, 20),
                child:
                    Icon(Icons.account_circle, size: 90, color: Colors.black),
              ),
              Positioned(
                  bottom: 25.0,
                  left: 22.0,
                  child: Text("What would you like to eat today?",
                      style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 100),
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500))),
            ])));
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}

class UserHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Home Page"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            // Navigate back to first route when tapped.
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
