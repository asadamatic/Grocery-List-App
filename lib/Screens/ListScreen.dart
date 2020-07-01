
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:groceylistapp/DataModels/GroceryItem.dart';
import 'package:groceylistapp/Screens/EditingScreen.dart';
import 'package:groceylistapp/Screens/HomeScreen.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ListScreen extends StatefulWidget{

  GroceryItem groceryItem;
  Category category;
  ListScreen({this.groceryItem, this.category});

  @override
  State createState() {
    return ListScreenState();
  }
}

class ListScreenState extends State<ListScreen>{

  List<GroceryItem> groceryItems = List();

  //String to bool conversion
  bool getStatus(String value) {

    return value == 'true' ? true : false;
  }

  //Database setup
  Future<Database> database;

  void initializeDB() async{

    database = openDatabase(
      join(await getDatabasesPath(), 'grocery.db'),
      onCreate: (db, version){

        return db.execute('CREATE TABLE grocerylist(time TEXT PRIMARY KEY, name TEXT, quantity TEXT, unit TEXT, category TEXT, status TEXT)');
      },
      version: 1,
    );
  }

  Future<List<Map<String, dynamic>>> retrieve() async{

    Database db = await database;
    List<Map<String, dynamic>> list = await db.query('grocerylist', where: 'category = "${widget.category.slug}"');

    return list;
  }
  void retrieveData() async{

    List<Map<String, dynamic>> tempList = await retrieve();
    List<GroceryItem> tempGroceryList = List();

    for (int index = 0; index < tempList.length; index++){
      tempGroceryList.add(GroceryItem(time: DateTime.parse(tempList[index]['time']), name: tempList[index]['name'], quantity: tempList[index]['quantity'], unit: tempList[index]['unit'], category: tempList[index]['category'], status: getStatus(tempList[index]['status'])));
    }

    setState(() {
      groceryItems = tempGroceryList;
    });

  }

  Future<void> insert(GroceryItem groceryItem) async {
    Database db = await database;
    await db.insert('grocerylist', groceryItem.toMap());
  }
  void insertData(GroceryItem groceryItem) async{

    await insert(groceryItem);
  }

  Future<void> update(GroceryItem groceryItem) async{

    Database db = await database;

    db.update('grocerylist', groceryItem.toMap(), where: 'time = ?', whereArgs: [groceryItem.time.toString()]);
  }
  void updateData(GroceryItem groceryItem) async{

    await update(groceryItem);
  }

  Future<void> delete(GroceryItem groceryItem) async{

    Database db = await database;

    db.delete('grocerylist', where: 'time = ?', whereArgs: [groceryItem.time.toString()]);
  }
  void deleteData(GroceryItem groceryItem) async{

    await delete(groceryItem);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeDB();
    if (widget.groceryItem != null){

      Future.delayed(Duration(seconds: 1)).then((value) {
        insertData(widget.groceryItem);
      });


    }
    Future.delayed(Duration(seconds: 1)).then((value) {
     retrieveData();
    });

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.category.name}'),
        ),
      body: ListView(
        children: groceryItems.map((groceryItem) => GroceryItemCard(key: UniqueKey(), groceryItem: groceryItem, category: widget.category, updateData: updateData, deleteData: deleteData, retrieveData: retrieveData,)).toList(),
      ),
        floatingActionButton: Builder(
          builder: (BuildContext newContext){
            return FloatingActionButton(
              child: Icon(
                Icons.add,
              ),
              onPressed: () async{
                dynamic result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditingScreen(category: widget.category,)));
                if (result != null){

                  insertData(result['groceryItem']);
                  setState(() {
                      retrieveData();
                  });
                }
              },
            );
          },
        )


      ),
    );
  }
}


class GroceryItemCard extends StatefulWidget{

  Function updateData, deleteData, retrieveData;
  GroceryItem groceryItem;
  Category category;
  Key key;
  GroceryItemCard({this.key, this.groceryItem, this.category, this.updateData, this.deleteData, this.retrieveData});

  @override
  State createState() {
    return GroceryItemCardState();
  }
}

class GroceryItemCardState extends State<GroceryItemCard> with SingleTickerProviderStateMixin{


  //Delete animation
  AnimationController animationController;
  Animation<Offset> animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    animation = Tween<Offset>(
        begin: Offset(0.0, 0.0),
        end: Offset(1.0, 0.0)
    ).animate(animationController);
  }
  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: animation,
      child: Card(
        elevation: 5.0,
        margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
          child: CheckboxListTile(
            dense: true,
            value: widget.groceryItem.status,
            controlAffinity: ListTileControlAffinity.leading,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text('${widget.groceryItem.name}', style: TextStyle(fontSize: 16.0, color: Colors.black87, fontWeight: FontWeight.bold, letterSpacing: 1.0),),
                ),
                IconButton(
                  color: Colors.grey[700],
                  icon: Icon(
                    Icons.edit,
                  ),
                  onPressed: () async{
                    dynamic result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditingScreen(groceryItem: widget.groceryItem,)));
                    if (result != null){
                      setState(() {
                        widget.updateData(result['groceryItem']);
                      });
                    }
                  },
                ),
              ],
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    children: <Widget>[
                      Text('${widget.groceryItem.quantity} ', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14.0, color: Colors.black.withOpacity(.7), letterSpacing: 0.8),),
                      Text(widget.groceryItem.unit == 'None' ? '': '${widget.groceryItem.unit}', maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.0, color: Colors.black.withOpacity(.7), letterSpacing: 0.8),),
                    ],
                  ),
                ),
                IconButton(
                  color: Colors.grey[700],
                  icon: Icon(
                    Icons.delete,
                  ),
                  onPressed: (){
                      animationController.forward();
                      Future.delayed(Duration(milliseconds: 500)).then((value) {
                        widget.deleteData(widget.groceryItem);
                        widget.retrieveData();
                      });
                  },
                ),
              ],
            ),
            onChanged: (newValue){
              setState(() {
                widget.groceryItem.status = newValue;
              });

              widget.updateData(widget.groceryItem);
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }
}