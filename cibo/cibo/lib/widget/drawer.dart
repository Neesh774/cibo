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
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('res/images/app_background.png'))),
        child: Stack(children: <Widget>[
          Positioned(
              bottom: 75.0,
              left: 30.0,
              child: Text("What would you like to eat today?",
                  style: TextStyle(
                      color: Color.fromRGBO(67, 76, 85, 100),
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500))),
        ]));
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
