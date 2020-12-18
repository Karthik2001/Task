import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_app/Operations/ToDos.dart';
import '../SizeConfig/Size.dart';
import '../Widgets/ToDoItem.dart';
import 'AddItem.dart';
import '../Operations/Authentication.dart';
import '../Operations/ReadAndWriteFile.dart';

class Feeds extends StatefulWidget {
  Feeds({
    this.auth,
    this.onSignedOut
  });
  final AuthImplementation auth;
  final VoidCallback onSignedOut;
  @override
  _FeedsState createState() => _FeedsState();
}

class _FeedsState extends State<Feeds> {
  int currentTime ;
  bool loading =true;
  int leftoverPrecentage=0;
  File jsonFile;
  Directory dir;
  String fileName = "ToDoList.json";
  bool fileExists = false;
  Map<String, dynamic> fileContent;
  var ToDoList=[];
  List<ToDos> L;

  laa(){
    setState(() {
      readFile();

    });
  }

 Future<List<ToDos>> readFile() async {
       L= await ReadAndWriteFile().readfromDatabase();
       L.sort((a,b) => b.minutes.compareTo(a.minutes));

       L=L.reversed.toList();
       print(L);
       return L;
  }

  @override
  void initState() {
    
    // TODO: implement initState

    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black54,
        appBar: AppBar(
          backgroundColor: Colors.black54,
          elevation: 0.1,
          title: Text("Let's Do",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'NunitoSans',
                fontSize: 9.33*SizeConfig.blockSizeHorizontal,
                color:  Colors.cyan[600],
              )
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add,
                color: Colors.cyan[600]
                ,size: 8.1*SizeConfig.blockSizeHorizontal,),
              color: Colors.white,
              onPressed:() {
                Navigator.of(context).push(new MaterialPageRoute(builder: (context)=>AddItem()));
              },
            ),
          ],
        ),
        body: FutureBuilder(
            future: readFile(),
          builder:(BuildContext context,AsyncSnapshot<List<ToDos>>snapshot){
              if(snapshot.hasData){
                return ListView.builder(
                      itemCount: L.length,
                      itemBuilder: (context, index) {
                        String name = L[index].title.toString();

                        String description = L[index].description.toString();
                        String time = L[index].time.toString();
                        String tid = L[index].tid.toString();


                        return ToDoItem(tid,name,description,time,laa);
                      },
                    );

              }
              if(!snapshot.hasData)
                {
                  return Center(
                    child: Text("No tasks yet",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'NunitoSans',
                          fontSize: 6.33*SizeConfig.blockSizeHorizontal,
                          color:  Colors.cyan[600],
                        )
                    ),
                  );
                }
              else{

                print(snapshot.data);
                return Center(child: CircularProgressIndicator());
              }
          }
        ),


      ),
    );
  }
}