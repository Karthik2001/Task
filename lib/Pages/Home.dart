import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../SizeConfig/Size.dart';
import 'AddItem.dart';
import '../Operations/Authentication.dart';
import 'Feeds.dart';
import 'Profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  Home({
    this.auth,
    this.onSignedOut
  });
  final AuthImplementation auth;
  final VoidCallback onSignedOut;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int currentTab=0;
  void set(){
    setState(()  {


      if(currentTab!=0)
        currentScreen=Feeds();

      currentTab=0;
    });
  }
  Future<String> getCurrentUserId()async
  {final FirebaseAuth _firebaseAuth= FirebaseAuth.instance;
  User user = await _firebaseAuth.currentUser;

  return user.uid;
  }
  Widget currentScreen =Feeds();
  final PageStorageBucket bucket = PageStorageBucket();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        backgroundColor: Colors.black54,
        body:PageStorage(
          child : currentScreen,
          bucket :bucket,
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 40,
          child: Container(
            margin: EdgeInsets.all(0),
            padding: EdgeInsets.fromLTRB(1.38*SizeConfig.blockSizeHorizontal,0.9*SizeConfig.blockSizeVertical,1.38*SizeConfig.blockSizeHorizontal,0.9*SizeConfig.blockSizeVertical,),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0*SizeConfig.blockSizeVertical),
                  topRight: Radius.circular(0*SizeConfig.blockSizeVertical)
              ),
              color:Colors.black,
            ),
            child: Row(

              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(0),
                  child: IconButton(
                      onPressed:() async {

                        setState(()  {


                          if(currentTab!=0)
                            currentScreen=Feeds();

                          currentTab=0;
                        }
                        );
                      },
                      icon: Icon(
                          Icons.home,
                          color: currentTab==0?Colors.white:Colors.cyan[600],
                          size:currentTab==0? 9*SizeConfig.blockSizeHorizontal:6.5*SizeConfig.blockSizeHorizontal
                      )
                  ),

                ),

                Container(
                  margin: EdgeInsets.all(0),
                  child: IconButton(
                      color: Colors.white,
                      onPressed:() async {
                        String uid = await getCurrentUserId();
                        if(currentTab!=3)
                          setState(() {

                            currentScreen=Profile(uid: uid);
                            currentTab=3;
                          });
                      },
                      icon: Icon(Icons.person_outline,
                          color: currentTab==3?Colors.white:Colors.cyan[600],
                          size:currentTab==3? 9*SizeConfig.blockSizeHorizontal:6.5*SizeConfig.blockSizeHorizontal
                      )
                  ),

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
