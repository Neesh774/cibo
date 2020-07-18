import 'package:flutter/material.dart';
import 'package:cibo/widget/drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

//C:\Users\kkanc\AndroidStudioProjects\cibo\cibo
List<TextEditingController> _newListIngs = [];
List<TextEditingController> _newlistnumIngs = [];
List<String> listFileNames = ['GroceryList_1'];

class ListsPage extends StatefulWidget {
  static const String routeName = '/grocery_lists';
  @override
  _ListsPageState createState() => new _ListsPageState();
}

class _ListsPageState extends State<ListsPage>
    with SingleTickerProviderStateMixin {
  var groceryListNames = [
    "Store 1",
    "Store 2",
    "Store 3",
    "Store 4",
    "Store 5"
  ];
  var numGroceryList = 5;
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Grocery Lists"),
          actions: <Widget>[
            IconButton(
              iconSize: 27.0,
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewGroceryListWidget()),
                );
              },
            )
          ],
        ),
        drawer: AppDrawer(),
        body: StreamBuilder(
            stream: Firestore.instance.collection("grocerylists").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                debugPrint(snapshot.data.documents.length.toString());
                return ListView.separated(
                    shrinkWrap: true,
                    itemCount: snapshot.data.documents.length,
                    separatorBuilder: (_, __) =>
                        const Divider(thickness: 2, height: 4.0),
                    itemBuilder: (context, index) {
                      DocumentSnapshot documentSnapshot =
                          snapshot.data.documents[index];
                      // String title = documentSnapshot['title'];
                      // ListTile(
                      //   dense: true,
                      //   trailing: const Icon(Icons.arrow_forward_ios),
                      //   title: Text(
                      //     title,
                      //     style: GoogleFonts.biryani(fontSize: 17.0),
                      //   ),
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => GroceryListPage(
                      //                 listTitle: "$title",
                      //               )),
                      //     );
                      //   },
                      // );
                      return ListTile(
                        title: Text(documentSnapshot['title'],
                            style: GoogleFonts.biryani(fontSize: 17.0)),
                        dense: true,
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GroceryListPage(
                                        listTitle: documentSnapshot['title'],
                                      )));
                        },
                      );
                    });
              }
            }));
  }
}

// ignore: must_be_immutable
class NewGroceryListWidget extends StatefulWidget {
  @override
  NewGroceryList createState() => NewGroceryList();
}

class NewGroceryList extends State<NewGroceryListWidget> {
  List<String> tempIngredients;
  final curTitle = new TextEditingController();
  int countings = 0;
  List<String> finalIngs = [];
  List<int> numfinalIngs = [];
  String _reminderDay = "Sunday";
  Widget build(BuildContext context) {
    debugPrint(curTitle.text);
    return Scaffold(
        appBar: AppBar(
          title: Text("New Grocery List"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListsPage()),
              );
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: new Icon(Icons.check, color: Colors.white),
              onPressed: () {
                debugPrint('$_newListIngs');
                debugPrint('$_newlistnumIngs');
                if (_newListIngs.isNotEmpty &&
                    _newlistnumIngs.isNotEmpty &&
                    (_newListIngs[0].text?.isNotEmpty ??
                        false) && //What if the Strings are null?
                    (_newlistnumIngs[0].text?.isNotEmpty ??
                        false) && //What if the Strings are null?
                    curTitle.text.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListsPage()),
                  );
                  for (int i = 0; i < _newListIngs.length; i++) {
                    finalIngs.add(_newListIngs[i].text);
                    int tempnum = int.parse(_newlistnumIngs[i].text);
                    numfinalIngs.add(tempnum);
                  }
                  List<String> tempIngs = [];
                  List<int> tempNumIngs = [];
                  for (int i = 0; i < finalIngs.length; i++) {
                    tempIngs.add(finalIngs[i]);
                    int tempnum = numfinalIngs[i];
                    tempNumIngs.add(tempnum);
                  }
                  GroceryList cur = GroceryList(
                      curTitle.text, _reminderDay, tempIngs, tempNumIngs);
                } else {
                  Alert(
                          context: context,
                          title: "Missing Ingredients.",
                          desc: "Please fill all blank spaces.")
                      .show();
                }
              },
            )
          ],
        ),
        drawer: AppDrawer(),
        body: Container(
          padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 30.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: curTitle,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Title',
                    hintText: 'What will you call your grocery list?'),
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Remind me every ',
                    style: GoogleFonts.biryani(fontSize: 15.0),
                  ),
                  DropdownButton<String>(
                    //Don't forget to pass your variable to the current value
                    value: _reminderDay,
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
                    onChanged: (newValue) {
                      setState(() {
                        _reminderDay = newValue;
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                      'Ingredients                                                                     ',
                      style: GoogleFonts.biryani(fontSize: 15.0)),
                  IconButton(
                    icon: new Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        countings++;
                      });
                      debugPrint('$countings');
                    },
                  )
                ],
              ),
              SizedBox(height: 10.0),
              ListOfIngsWidget(countings, key: UniqueKey())
            ],
          ),
        ));
  }
}

class GroceryListPage extends StatelessWidget {
  final String listTitle;
  GroceryListPage({@required this.listTitle});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$listTitle"),
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

class GroceryList {
  String title = "";
  String _reminderDay = "";
  List<String> ingredients = [];
  List<int> numIngs = [];
  GroceryList(
    this.title,
    this._reminderDay,
    this.ingredients,
    this.numIngs,
  );
}

class ListOfIngsWidget extends StatefulWidget {
  final int countIngs;

  const ListOfIngsWidget(this.countIngs, {Key key}) : super(key: key);

  @override
  _ListOfIngsState createState() => _ListOfIngsState();
}

class _ListOfIngsState extends State<ListOfIngsWidget> {
  List<TextEditingController> _controllerList = [];
  List<TextEditingController> _numControllerList = [];
  List<Widget> _ingList = [];

  @override
  void initState() {
    for (int i = 1; i <= widget.countIngs; i++) {
      TextEditingController controller = TextEditingController();
      TextField textField = TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Ingredient $i',
        ),
      );
      TextEditingController numcontroller = TextEditingController();
      TextField numField = TextField(
        controller: numcontroller,
        decoration: InputDecoration(
            border: OutlineInputBorder(), hintText: '#', labelText: '#'),
        keyboardType: TextInputType.number,
      );
      _ingList.add(Row(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: SizedBox(
                width: 250,
                child: textField,
              )),
          Text('x', style: GoogleFonts.biryani(fontSize: 15)),
          Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: SizedBox(
                width: 75,
                child: numField,
              ))
        ],
      ));
      _controllerList.add(controller);
      _numControllerList.add(numcontroller);
      _newListIngs.add(controller);
      _newlistnumIngs.add(numcontroller);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Flexible(
        child: ListView(children: _ingList),
      ),
    );
  }
}
