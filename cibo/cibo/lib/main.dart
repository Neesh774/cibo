import 'package:flutter/material.dart';
import 'package:cibo/routes/Routes.dart';
import 'module/contacts/recipes_list_view.dart';
import 'injection/dependency_injection.dart';
import 'module/events/grocery_lists_list_view.dart';
import 'module/notes/stores_list_view.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
//C:\Users\kkanc\AndroidStudioProjects\cibo\cibo
void main() {
  Injector.configure(Flavor.PRO);

  runApp(
    new MaterialApp(

      title: 'cibo',
      debugShowCheckedModeBanner: false,

      home: RecipesPage(),
      routes:  {
        Routes.recipes: (context) => RecipesPage(),
        Routes.grocery_lists: (context) => ListsPage(),
        Routes.local_stores: (context) => StoresPage(),
      },
    )
  );
}
