import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:movie_flix/models/movie.dart';
import 'package:movie_flix/screens/add_edit_screen.dart';
import 'package:movie_flix/utils/constants.dart';
import 'package:movie_flix/utils/database_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool loading = false;
  List<Movie> movieList = new List<Movie>();
  var db = new DatabaseHelper();

  setupDB() async {
    // await db.saveData(Movie("https://picsum.photos/200", "Race 3", "Rohit Shetty"));
    loading = true;
    setState(() {});
    List items = await db.getItems();
    movieList.clear();
    items.forEach((item) {
      movieList.add(Movie.map(item));
    });
    loading = false;
    setState(() {});
  }

  @override
  void initState() {
    setupDB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text("Home",style: TextStyle(color: primaryColor)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          await Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditScreen()));
          setupDB();
        },
        child: Icon(Icons.add),
      ),
      body: movieList.length>0 ? ListView.builder(
        itemCount: movieList.length,
          itemBuilder: (ctx,index){
        return Slidable(
          actionPane: SlidableDrawerActionPane(),
          actions: [
            IconSlideAction(
              caption: 'Edit',
              color: Colors.blue,
              icon: Icons.edit,
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    AddEditScreen(movie: movieList[index])));
                setupDB();
              }
            ),
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () async {
                print(await db.deleteItem(movieList[index].getId));
                setupDB();
              },
            ),
          ],
          child: ListTile(
            leading: ClipRRect(child: Image.network(movieList[index].getImageURL),borderRadius: BorderRadius.all(Radius.circular(100)),),
            title: Text(movieList[index].getName,style: TextStyle(color: primaryColor,fontSize: 18,fontWeight: FontWeight.w500),),
            subtitle: Text(movieList[index].getDirector,style: TextStyle(color: Colors.white)),
          ),
        );
      }) : loading ? Center(child: CircularProgressIndicator(),) : Center(child: Text("No Items",style: TextStyle(color: Colors.white,fontSize: 20)),),
    );
  }
}
