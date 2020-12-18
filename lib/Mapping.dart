import'package:flutter/material.dart';
import 'Pages/Loading.dart';
import 'Pages/Login.dart';
import 'Pages/Home.dart';
import 'Operations/Authentication.dart';

class MappingPage extends StatefulWidget {
  final Auth auth=Auth();
  MappingPage();
  @override
  _MappingPageState createState() => _MappingPageState();

}

enum AuthStatus{
  notSignedIn,
  SignedIn,
  none
}

class _MappingPageState extends State<MappingPage> {
  AuthStatus authStatus= AuthStatus.notSignedIn;

  @override
  initState()  {

    super.initState();

       widget.auth.getCurrentUser().then((firebaseUserID)
    { if(firebaseUserID!=null)
      setState(() {

        authStatus=firebaseUserID==null?AuthStatus.notSignedIn:AuthStatus.SignedIn;
        print(firebaseUserID);
      });
    });
  }


  void _signedIn()
  {
    setState(() {
      authStatus=AuthStatus.SignedIn;
    });
  }

  void _signedOut()
  {
    setState(() {
      authStatus=AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch(authStatus)
    {
      case AuthStatus.SignedIn:
        return Home(
            auth:widget.auth,
            onSignedOut:_signedOut
        );
      case AuthStatus.notSignedIn:
        return Login(
            auth:widget.auth,
            onSignedIn:_signedIn
        );
      case AuthStatus.none:
        return Loading();
    }
  }
}
