
import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'ToDoTask.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'package:uuid/uuid.dart';


import 'package:path_provider/path_provider.dart';

import 'ToDos.dart';
class ReadAndWriteFile{
  File jsonFile;
  Directory dir;
  String fileName = "ToDoList.json";
  bool fileExists = false;
  Map<String, dynamic> fileContent;
  var ToDoList=[];







  Future<String> getCurrentUserid()async
  {final FirebaseAuth _firebaseAuth= FirebaseAuth.instance;
  User user = await _firebaseAuth.currentUser;

  return user.uid;
  }

 Future<List<String>> readprofiledetails() async {
    String uid =await getCurrentUserid();
    String name,url,email;
    DatabaseReference todosref =  FirebaseDatabase.instance.reference().child("Users").child(uid);
    await todosref.once().then((DataSnapshot snap) async{
      var Keys = snap.value.keys;
      var Data=snap.value;

      name=Data['Userdetails']['name'];
      url=Data['Userdetails']['profileurl'];
      email=Data['Userdetails']['email'];



    });


    return [name,url,email];
  }
  Future<void> deletefromDatabase(String tid,VoidCallback set) async {

    String uid =await getCurrentUserid();
    DatabaseReference dbref = FirebaseDatabase.instance.reference();
    await dbref.child("Users").child(uid).child("ToDoList").child(tid).remove();
    set();
  }
  void saveToDatabase(ToDoTask T) async {
    String uid =await getCurrentUserid();
    String uuid = Uuid().v4();
    print(uid);
    DatabaseReference dbref = FirebaseDatabase.instance.reference();

    var data={

      "title":T.title,
      "description":T.description,
      "time":T.time,
      "uid":uid,
      "minutes":T.minutes,


    };
    await dbref.child("Users").child(uid).child("ToDoList").child(uuid).set(data).whenComplete(() => print("done"));
    print("yes");
  }
  void editProfile(String email, String name,String profileurl) async {
    String uid = await getCurrentUserid();
    DatabaseReference dbref = await FirebaseDatabase.instance.reference();
    var data={
      "uid":uid,
      "name":name,
      "email":email,
      "profileurl":profileurl,


    };
    await dbref.child("Users").child(uid).child("Userdetails").set(data);



  }

  Future<List> readfromDatabase() async {

    List<ToDos> ToDosList =[];
    String uid =await getCurrentUserid();
    DatabaseReference todosref =  FirebaseDatabase.instance.reference().child("Users").child(uid).child("ToDoList");
    await todosref.once().then((DataSnapshot snap) async{
      var Keys = snap.value.keys;
      var Data=snap.value;


      ToDosList.clear();
      for(var individualKeys in Keys)
      {
        ToDos toDos = ToDos(
            Data[individualKeys]['title'],
            individualKeys,
            Data[individualKeys]['description'],
            Data[individualKeys]['time'],
            Data[individualKeys]['minutes']
        );
        ToDosList.add(toDos);

      }


    });


    return ToDosList;
  }
}