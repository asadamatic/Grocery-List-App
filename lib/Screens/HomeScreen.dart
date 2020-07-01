import 'package:flutter/material.dart';
import 'package:groceylistapp/Screens/EditingScreen.dart';
import 'package:groceylistapp/Screens/ListScreen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{

  List<Category> categories = [
    Category(name: 'Beverages', slug: 'beverages', image: 'Assets/beverages.png'),
    Category(name: 'Vegetables', slug: 'vegetables', image: 'Assets/vegetables.png'),
    Category(name: 'Dairy', slug: 'dairy', image: 'Assets/dairy.png'),
    Category(name: 'Frozen Foods', slug: 'frozenfoods', image: 'Assets/frozenfoods.png'),
    Category(name: 'Meat', slug: 'meat', image: 'Assets/meat.png'),
    Category(name: 'Personal Care', slug: 'personalcare', image: 'Assets/personalcare.png'),];


  //Animation Conteollers
  AnimationController animationController;
  Animation<RelativeRect> animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..forward();
    animation = RelativeRectTween(
      begin: RelativeRect.fromLTRB(0.0, 80.0, 0.0, 0.0),
      end: RelativeRect.fromLTRB(0.0, 120.0, 0.0, 0.0),
    ).animate(animationController);

  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              height: 200.0,
              color: Colors.blue,
            ),
            Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Grocery List', style: TextStyle(fontSize: 36.0, color: Colors.white, fontWeight: FontWeight.bold),),
                      SizedBox(width: 10.0,),
                      Image(
                        height: 55.0,
                        image: AssetImage('Assets/homeicon.png'),
                      ),
                    ],
                  ),
                )
            ),
            Container(),
            PositionedTransition(
              rect: animation,
              child: TweenAnimationBuilder(
                tween: Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ),
                duration: Duration(milliseconds: 500),
                builder: (context, opacity, child){

                  return AnimatedOpacity(
                    duration: Duration(milliseconds: 500),
                    opacity: opacity,
                    child: GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      children: categories.map((category) => CategoryTile(category: category,)).toList(),
                    ),
                  );
                },
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
          ),
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditingScreen()));
          },
        ),
      ),
    );
  }
}

class CategoryTile extends StatefulWidget{

  Category category;
  CategoryTile({this.category});

  @override
  _CategoryTileState createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        elevation: 5.0,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: Image(
                  height: 50.0,
                  image: AssetImage(widget.category.image),
                ),
              ),
              Container(
                child: Text('${widget.category.name}', style: TextStyle(fontSize: 16.0),),
              )
            ],
          ),
        ),
      ),
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListScreen(category: widget.category,)));
      },
    );
  }
}

class Category{

  String name, slug, image;

  Category({this.name, this.slug, this.image});
}