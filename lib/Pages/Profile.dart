import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:task_app/Operations/ToDos.dart';
import 'package:task_app/Widgets/ToDoItem.dart';

import '../SizeConfig/Size.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../Operations/Authentication.dart';

import '../SizeConfig/Size.dart';
import '../Widgets/ToDoItem.dart';
import 'AddItem.dart';
import '../Operations/Authentication.dart';
import '../Operations/ReadAndWriteFile.dart';
import 'EditProfile.dart';


class Profile extends StatefulWidget {
  String uid;

  var status='a',url='a',branch='a',skills='a',email='a',phoneNUmber='a',schoolname='a',worksat='a',username='a';
  Profile({this.uid});

  int liked=0,blogcount=0;


  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  String username='';
  String url;
  bool loading=true;
  int currentTime ;
  int leftoverPrecentage=0;
  File jsonFile;
  Directory dir;
  String fileName = "ToDoList.json";
  bool fileExists = false;
  Map<String, dynamic> fileContent;
  var ToDoList=[];
  List<dynamic> L;


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

  Future<String> getCurrentUserId()async
  {final FirebaseAuth _firebaseAuth= FirebaseAuth.instance;
  User user = await _firebaseAuth.currentUser;
  return user.uid;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,

      body:ListView(
        children: <Widget>[
          Container(
            height :32*SizeConfig.blockSizeVertical,
            child: FutureBuilder(
              future: ReadAndWriteFile().readprofiledetails(),
              builder: (BuildContext context,AsyncSnapshot<List<String>> l){
                if(l.hasData)
                  { List<String> details = l.data;
                    return  Column(
                        children:<Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(5.5*SizeConfig.blockSizeHorizontal, 3.09*SizeConfig.blockSizeVertical, 0*SizeConfig.blockSizeHorizontal, 0),
                            child: Row(


                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(details[1]),
                                    radius : 7.27*SizeConfig.blockSizeVertical,
                                    backgroundColor: Colors.white70,
                                  ),
                                  Container(
                                    margin:  EdgeInsets.fromLTRB(2.77*SizeConfig.blockSizeHorizontal,3.63*SizeConfig.blockSizeVertical,0,0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(details[0],
                                          style: TextStyle(
                                              fontSize: 5.5*SizeConfig.blockSizeHorizontal,
                                              fontFamily: 'NunitoSans',


                                              color:Colors.white
                                          ),
                                        ),
                                        Text(details[2],
                                          style: TextStyle(
                                              fontSize: 3.6*SizeConfig.blockSizeHorizontal,
                                              fontFamily: 'NunitoSans',
                                              fontWeight: FontWeight.bold,

                                              color:Colors.white70
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),]),
                          ),
                          FlatButton(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(5.5*SizeConfig.blockSizeHorizontal, 3.63*SizeConfig.blockSizeVertical, 5.5*SizeConfig.blockSizeHorizontal, 0),

                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(

                                    child: FlatButton(

                                      onPressed:() {
                                        Navigator.of(context).pop();
                                        Auth().signOut();
                                        Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
                                        //  Navigator.of(context).push(new MaterialPageRoute(builder: (context)=>EditProfile(uid: widget.uid,email:widget.email,phoneNUmber:widget.phoneNUmber,url:widget.url,school:widget.schoolname,name:widget.username,skills:widget.skills,company:widget.worksat,status:widget.status,branch:widget.branch)));
                                      },
                                      padding: EdgeInsets.all(0),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: new BorderRadius.circular(2.18*SizeConfig.blockSizeVertical),
                                          side: BorderSide(color: Colors.white70,)
                                      ),
                                      // color: Color(0XFF00857C),
                                      child: Text('Log OUt',
                                        style: TextStyle(
                                            fontSize: 3.3*SizeConfig.blockSizeHorizontal,
                                            fontFamily: 'NunitoSans',
                                            fontWeight: FontWeight.bold,
                                            color:Colors.white
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(

                                    child: FlatButton(


                                      padding: EdgeInsets.all(0),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: new BorderRadius.circular(2.18*SizeConfig.blockSizeVertical),
                                          side: BorderSide(color: Colors.white70,)
                                      ),
                                      // color: Color(0XFF00857C),
                                      child: Text('Edit Profile',
                                        style: TextStyle(
                                            fontSize: 3.3*SizeConfig.blockSizeHorizontal,
                                            fontFamily: 'NunitoSans',
                                            fontWeight: FontWeight.bold,
                                            color:Colors.white
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onPressed:((){
                              Navigator.of(context).push(new MaterialPageRoute(builder: (context)=>EditProfile(name: details[0],email:details[2],profileurl:details[1],set:laa)));
                            }),

                          ),


                        ]
                    );
                  }
                if(!l.hasData)
                  {
                    return Center(child: CircularProgressIndicator());
                  }
                else{
                  return Center(child: CircularProgressIndicator());
                }
            },
            ),
          ),

          //User_information(),
          Container(
            decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.only(topRight: Radius.circular(5.5*SizeConfig.blockSizeHorizontal),topLeft:Radius.circular(5.5*SizeConfig.blockSizeHorizontal))
            ),
            padding: EdgeInsets.all(1.0),
            height:70*SizeConfig.blockSizeVertical,
            //constraints: BoxConstraints.expand(),
            margin: EdgeInsets.fromLTRB(0,1.8*SizeConfig.blockSizeVertical,0,0),
            child: FutureBuilder(
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
          // UserDetails(),

        ],
      ),
    );
  }

}



















Widget _buidContainer(String Tag,String Info,String url) {

  return Container(
    margin: EdgeInsets.only(top: 2*SizeConfig.blockSizeVertical,left:1.38*SizeConfig.blockSizeHorizontal,right: 1.38*SizeConfig.blockSizeHorizontal),
    height: 15*SizeConfig.blockSizeVertical,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(1.68*SizeConfig.blockSizeVertical),
          topRight:Radius.circular(1.68*SizeConfig.blockSizeVertical),
          bottomLeft: Radius.circular(1.68*SizeConfig.blockSizeVertical),
          bottomRight: Radius.circular(1.68*SizeConfig.blockSizeVertical)
      ),
      color: Colors.grey[200],

    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[

            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:<Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 2.7*SizeConfig.blockSizeHorizontal,top: 4.5,right: 1.94*SizeConfig.blockSizeHorizontal,bottom: 1.8*SizeConfig.blockSizeVertical),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(url),
                      radius : 15 ,
                      backgroundColor: Colors.black54,
                    ),
                  ),

                  Text(Tag,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 3.8*SizeConfig.blockSizeHorizontal,
                        fontWeight: FontWeight.w700, fontFamily: 'NunitoSans',
                        //fontFamily:'Courgette',
                        color:Colors.black87),
                  ),

                ]
            ),
          ],
        ),
        Padding(
          padding:  EdgeInsets.fromLTRB(3.88*SizeConfig.blockSizeHorizontal, 1.45*SizeConfig.blockSizeVertical, 2.22*SizeConfig.blockSizeHorizontal,1.45*SizeConfig.blockSizeVertical ),
          child: Text(Info,
            textAlign: TextAlign.right,
            style: TextStyle(
                fontSize: 4.1*SizeConfig.blockSizeHorizontal,
                fontWeight: FontWeight.w700, fontFamily: 'NunitoSans',
                //fontFamily:'Courgette',
                color:Colors.black87),
          ),
        ),
      ],

    ),
  );
}












