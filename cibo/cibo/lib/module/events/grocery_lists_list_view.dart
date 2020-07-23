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
                return Container(
                    child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        separatorBuilder: (_, __) =>
                            const Divider(thickness: 2, height: 4.0),
                        itemBuilder: (context, index) {
                          DocumentSnapshot documentSnapshot =
                              snapshot.data.documents[index];
                          return ListTile(
                            title: Text(documentSnapshot['title'],
                                style: GoogleFonts.biryani(fontSize: 17.0)),
                            dense: true,
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              List<String> ings = [];
                              List<int> numIngs = [];
                              for (int i = 0;
                                  i < documentSnapshot['ingredients'].length;
                                  i++) {
                                ings.add(documentSnapshot['ingredients'][i]);
                                numIngs.add(documentSnapshot['numIngs'][i]);
                              }
                              GroceryList list = new GroceryList(
                                  documentSnapshot['title'],
                                  documentSnapshot['reminderDay'],
                                  ings,
                                  numIngs);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => GroceryListPage(
                                            list: list,
                                          )));
                            },
                          );
                        }));
              } else {
                return Container(width: 0.0, height: 0.0);
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
  final numOfIngscontroller = new TextEditingController();
  int countings = 0;
  List<String> finalIngs = [];
  List<int> numfinalIngs = [];
  String _reminderDay = "Sunday";
  int numOfIngs = 0;
  TextEditingController controller = new TextEditingController();
  TextEditingController numcontroller = new TextEditingController();
  Widget build(BuildContext context) {
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
              onPressed: () async {
                if (_newListIngs.isNotEmpty &&
                    _newlistnumIngs.isNotEmpty &&
                    (_newListIngs[0].text?.isNotEmpty ??
                        false) && //What if the Strings are null?
                    (_newlistnumIngs[0].text?.isNotEmpty ??
                        false) && //What if the Strings are null?
                    curTitle.text.isNotEmpty) {
                  _newListIngs.clear();
                  _newlistnumIngs.clear();
                  debugPrint('$_newListIngs');
                  debugPrint("$_newlistnumIngs");
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
                  debugPrint('$tempIngs');
                  debugPrint('$tempNumIngs');
                  GroceryList cur = GroceryList(
                      curTitle.text, _reminderDay, tempIngs, tempNumIngs);
                  final db = Firestore.instance;
                  await db.collection('grocerylists').add({
                    'title': cur.title,
                    'reminderDay': cur._reminderDay,
                    'ingredients': tempIngs,
                    'numIngs': tempNumIngs
                  });
                  curTitle.clear();
                  _reminderDay = "";
                  finalIngs.clear();
                  numfinalIngs.clear();
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
                  SizedBox(
                    width: 75,
                    height: 50,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: numOfIngscontroller,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '#',
                          hintText: '#'),
                      onSubmitted: (numIngredients) {
                        debugPrint(numIngredients);
                        setState(() {
                          numOfIngs = int.parse(numIngredients);
                        });
                      },
                    ),
                  ),
                  Text('   Ingredients',
                      style: GoogleFonts.biryani(fontSize: 15)),
                ],
              ),
              new Expanded(
                  child: ListView.builder(
                itemCount: numOfIngs,
                itemBuilder: (BuildContext context, int index) {
                  int count = index + 1;
                  return Column(children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                          child: TextField(
                            controller: controller,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Ingredient $count',
                            ),
                          ),
                        ),
                        Spacer(),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: numcontroller,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: '#',
                                labelText: '#'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    )
                  ]);
                },
              ))
            ],
          ),
        ));
  }
}

class GroceryListPage extends StatelessWidget {
  final GroceryList list;
  GroceryListPage({@required this.list});
  @override
  Widget build(BuildContext context) {
    String listTitle = list.title;
    String listday = list._reminderDay;
    List<String> listIngs = list.ingredients;
    List<int> listNumIngs = list.numIngs;
    List<Color> selectedDayColor = [
      Colors.black,
      Colors.black,
      Colors.black,
      Colors.black,
      Colors.black,
      Colors.black,
      Colors.black
    ];
    if (listday == 'Sunday') {
      selectedDayColor[0] = Colors.greenAccent;
    } else if (listday == 'Monday') {
      selectedDayColor[1] = Colors.greenAccent;
    } else if (listday == 'Tuesday') {
      selectedDayColor[2] = Colors.greenAccent;
    } else if (listday == 'Wednesday') {
      selectedDayColor[3] = Colors.greenAccent;
    } else if (listday == 'Thursday') {
      selectedDayColor[4] = Colors.greenAccent;
    } else if (listday == 'Friday') {
      selectedDayColor[5] = Colors.greenAccent;
    } else if (listday == 'Saturday') {
      selectedDayColor[6] = Colors.greenAccent;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("$listTitle"),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.edit), onPressed: () {})
          ],
        ),
        body: StreamBuilder(
            stream: Firestore.instance.collection("grocerylists").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                    padding: EdgeInsets.only(top: 25),
                    child: Column(
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: 275,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('S',
                                            style: GoogleFonts.biryani(
                                                fontSize: 22.5,
                                                color: selectedDayColor[0])),
                                        Spacer(),
                                        Text('M',
                                            style: GoogleFonts.biryani(
                                                fontSize: 22.5,
                                                color: selectedDayColor[1])),
                                        Spacer(),
                                        Text('T',
                                            style: GoogleFonts.biryani(
                                                fontSize: 22.5,
                                                color: selectedDayColor[2])),
                                        Spacer(),
                                        Text('W',
                                            style: GoogleFonts.biryani(
                                                fontSize: 22.5,
                                                color: selectedDayColor[3])),
                                        Spacer(),
                                        Text('T',
                                            style: GoogleFonts.biryani(
                                                fontSize: 22.5,
                                                color: selectedDayColor[4])),
                                        Spacer(),
                                        Text('F',
                                            style: GoogleFonts.biryani(
                                                fontSize: 22.5,
                                                color: selectedDayColor[5])),
                                        Spacer(),
                                        Text('S',
                                            style: GoogleFonts.biryani(
                                                fontSize: 22.5,
                                                color: selectedDayColor[6])),
                                      ],
                                    ),
                                  )
                                ]),
                          ],
                        )
                      ],
                    ));
              } else {
                return Container();
              }
            }));
  }
}

class ListOfIngs extends StatelessWidget {
  @override
  ListOfIngs(TextEditingController controller,
      TextEditingController numcontroller, int i);
  Widget build(BuildContext context) {
    TextEditingController controller;
    TextEditingController numcontroller;
    int i;
    debugPrint('recieved');
    return SizedBox(
      width: 300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Ingredient $i',
              ),
              onSubmitted: (ing) {
                _newListIngs.add(controller);
              }),
          TextField(
              controller: numcontroller,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: '#', labelText: '#'),
              keyboardType: TextInputType.number,
              onSubmitted: (numIng) {
                _newlistnumIngs.add(numcontroller);
              }),
        ],
      ),
    );
  }
}

class GroceryList {
  var title = "";
  var _reminderDay = "";
  List<String> ingredients = [];
  List<int> numIngs = [];
  GroceryList(
    this.title,
    this._reminderDay,
    this.ingredients,
    this.numIngs,
  );
}

class Drawhorizontalline extends CustomPainter {
  Paint _paint;

  Drawhorizontalline() {
    _paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(Offset(-90.0, 0.0), Offset(90.0, 0.0), _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
