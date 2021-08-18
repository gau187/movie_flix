import 'package:flutter/material.dart';
import 'package:movie_flix/models/movie.dart';
import 'package:movie_flix/utils/constants.dart';
import 'package:movie_flix/utils/database_helper.dart';

class AddEditScreen extends StatefulWidget {
  final Movie movie;
  const AddEditScreen({Key key,this.movie}) : super(key: key);

  @override
  _AddEditScreenState createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {

  var db = new DatabaseHelper();
  TextEditingController imageController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController directorController = TextEditingController();

  Widget buildTF1(
      String title,
      TextEditingController controller,
      BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        maxLength: 200,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: UnderlineInputBorder(borderSide: BorderSide(
              color: primaryColor
          )),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(
              color: primaryColor
          )),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(
              color: primaryColor
          )),
          errorBorder: UnderlineInputBorder(borderSide: BorderSide(
              color: primaryColor
          )),
          disabledBorder: UnderlineInputBorder(borderSide: BorderSide(
              color: primaryColor
          )),
          counterText: '',
          hintText: title,
          contentPadding: EdgeInsets.only(top: 6, bottom: 6),
          hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.7)),
          labelStyle: TextStyle(
              color: Colors.white.withOpacity(0.7)),
        ),
      ),
    );
  }

  populateData(){
    if(widget.movie!=null){
      imageController.text = widget.movie.getImageURL;
      nameController.text = widget.movie.getName;
      directorController.text = widget.movie.getDirector;
    }
    setState(() {});
  }

  addOrUpdate() async{
    if(imageController.text.isEmpty){
      showToast(context, "Fill image url");
      return;
    }
    if(nameController.text.isEmpty){
      showToast(context, "Fill name");
      return;
    }
    if(directorController.text.isEmpty) {
      showToast(context, "Fill director name");
      return;
    }
    Movie m = Movie(imageController.text,nameController.text,directorController.text);
    if(widget.movie!=null){
      print(await db.updateData(m,widget.movie.getId));
      showToast(context, "Edited");
      Navigator.pop(context);
    }else{
      print(await db.saveData(m));
      showToast(context, "Added");
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    populateData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(widget.movie!=null ? "Edit" : "Add",style: TextStyle(color: primaryColor)),
      ),
      body: ListView(
        children: [
          buildTF1("Image Url", imageController, context),
          buildTF1("Name", nameController, context),
          buildTF1("Director", directorController, context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: buildBtn("Save", addOrUpdate),
          )
        ],
      ),
    );
  }
}
