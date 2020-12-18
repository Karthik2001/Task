
import 'package:firebase_auth/firebase_auth.dart';
import '../Operations/Authentication.dart';
import 'Home.dart';

import '../Operations/Userdetails.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../Widgets/Dailogbox.dart';
import 'Loading.dart';
import '../SizeConfig/Size.dart';
class Login extends StatefulWidget {
  final AuthImplementation auth;
  final VoidCallback onSignedIn;
  Login({this.auth,this.onSignedIn});

  @override
  _LoginState createState() => _LoginState();
}

enum FormType
{
  login,register
}


class _LoginState extends State<Login> {
  DialogBox dialogBox= DialogBox();

  final formKey= GlobalKey<FormState>();
  FormType _formType =FormType.login;
  String email="";
  String password ="";
  String name ="";
  bool loading =false;
  final node = FocusNode();




  bool validateAndSave(){
    final form =formKey.currentState;
    if(form.validate())
    {
        form.save();
        return true;
    }
    else{
      return false;
        }


  }
  void validateAndSubmit()async
  {
    if (validateAndSave())
      {
        setState(() {
          loading=true;
        });
        try{
          if(_formType==FormType.login)
            {
              String userId =await widget.auth.SignIn(email, password,name);

              print("login userId ="+userId);
              if (userId!=null)
                {
                  setState(() {
                    loading = false;
                  });
                  Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (context)=>Home()));
                  widget.onSignedIn();
                }

            }
          else
            {
              User user =await widget.auth.SignUp(email, password,name);
               try {print("r userId ="+ user.uid);}
               catch(e){
                 print(e);
               }


             try{ if (user.uid!=null)
                 {  StoreUser userdetails = StoreUser(name);
                 String uid = await userdetails.storeUserDetails( user,email, name);
               if( uid!=null)
                {
                  DatabaseReference dbref = await FirebaseDatabase.instance.reference();
                  var data={
                    "uid":uid,
                    "name":name,
                    "email":email,
                    "profileurl":"https://images.unsplash.com/photo-1511367461989-f85a21fda167?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1189&q=80",


                  };
                  await dbref.child("Users").child(uid).child("Userdetails").set(data);



                  String Username =await widget.auth.getCurrentUsername();
                  Navigator.of(context).pop();
                  Navigator.of(context).push(new MaterialPageRoute(builder: (context) => Home()));
                }
               else
                 {
                   //print(widget.userdetails.storeUserDetails( user, name, branch, phoneNumber,state));
                 }

              }}
              catch(e){
               print(e);
              }

            }


        }
        catch(e) {
          dialogBox.information(context,"A Error",e.toString());
          setState(() {
            loading=false;
          });



    }
      }
  }

   void moveToRegister ()
   {
     formKey.currentState.reset();
     setState(() {
       _formType=FormType.register;
     });
   }

  void moveToLogin()
  {
    formKey.currentState.reset();
    setState(() {
      _formType=FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading==true? Loading():SafeArea(
      child: Scaffold(

        backgroundColor: Colors.black54,
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: true,



        body:Container(
          margin: EdgeInsets.fromLTRB(4.166*SizeConfig.blockSizeHorizontal,2.727*SizeConfig.blockSizeVertical,4.166*SizeConfig.blockSizeHorizontal,2.727*SizeConfig.blockSizeVertical),
          child: Form(
            key:formKey,
            child: ListView(
             shrinkWrap: true,
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget> [

                createInputs(),


                createButtons(),

              ]
            ),
          ),
        ),
      ),
    );
  }

  Widget createInputs()
  {
    if(_formType==FormType.login)
   {
    return Column(
        children:<Widget>[
      SizedBox(height: 5.45*SizeConfig.blockSizeVertical),


      SizedBox(height: 3*SizeConfig.blockSizeVertical),
      Text('Task ',textAlign: TextAlign.center,style: TextStyle(fontSize: 8.3*SizeConfig.blockSizeHorizontal,fontFamily: 'NunitoSans', color:  Colors.cyan[600],),),

      SizedBox(height: 5*SizeConfig.blockSizeVertical),


      Material(
        borderRadius: BorderRadius.circular(2.7*SizeConfig.blockSizeVertical),
         color:  Colors.blueGrey,
        child: Padding(
          padding:  EdgeInsets.fromLTRB(2.2*SizeConfig.blockSizeHorizontal,1.4545*SizeConfig.blockSizeVertical,2.2*SizeConfig.blockSizeHorizontal,1.4545*SizeConfig.blockSizeVertical),
          child: TextFormField(
            autocorrect: true,

            onFieldSubmitted: (v){
              setState(() {

              });
              FocusScope.of(context).requestFocus(node);
           },
            decoration: InputDecoration(hintText: '  Username',
              //border:OutlineInputBorder(),
              icon:Icon(Icons.person),
            ),

            validator: (value)
            {return value.isEmpty?'Email is required ':null;
            },
            onSaved: (value)
            {
              email=value;
            },

          ),
        ),
      ),

      SizedBox(height:5*SizeConfig.blockSizeVertical),

      Material(
        borderRadius: BorderRadius.circular(2.7*SizeConfig.blockSizeVertical),
        color:  Colors.blueGrey,
        elevation: 0.0,

        child: Padding(
          padding:  EdgeInsets.fromLTRB(2.2*SizeConfig.blockSizeHorizontal,1.4545*SizeConfig.blockSizeVertical,2.2*SizeConfig.blockSizeHorizontal,1.4545*SizeConfig.blockSizeVertical),
          child: TextFormField(
            autocorrect: true,
            focusNode: node,

            decoration:InputDecoration(hintText:'   Password',icon:Icon(Icons.lock_open),),
            obscureText: true,
            validator: (value)
            {return value.length>=8?null:'Please create a 8 digit password';
            },
            onSaved: (value)
            {
              password=value;
            },
          ),
        ),
      ),

    ]);
   }
    else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
          children:<Widget>[

        SizedBox(height: 5.45*SizeConfig.blockSizeVertical),

        Text('Task ',textAlign: TextAlign.center,style: TextStyle(fontSize: 8.3*SizeConfig.blockSizeHorizontal,fontFamily:'NunitoSans',color:Colors.cyan[600]),),

        SizedBox(height: 2.7*SizeConfig.blockSizeVertical),


        TextFormField(
          style: TextStyle(
            color: Colors.white70,
            //TextFormField title background color change
          ),
          decoration: InputDecoration(labelText: ' Email',
              labelStyle: TextStyle(

                  color:  Colors.cyan[600]
              )
          ),
          autocorrect: true,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (v){
            FocusScope.of(context).nextFocus(); // move focus to next
          },

          validator: (value)
          {return value.isEmpty?'Email is required ':null;
          },
          onSaved: (value)
          {
            email=value;
          },

        ),
        SizedBox(height:0.9*SizeConfig.blockSizeVertical),

        TextFormField(
          cursorColor: Colors.white,
          style: TextStyle(
            color: Colors.white70,
           //TextFormField title background color change
          ),
          decoration: InputDecoration(labelText: ' Name',
              labelStyle: TextStyle(

                  color:  Colors.cyan[600]
              )
          ),
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (v){
            FocusScope.of(context).nextFocus(); // move focus to next
          },
          autocorrect: true,
          validator: (value) {
            return value.isEmpty?'Please enter your name ':null;
            },
          onSaved: (value) {
            setState(() {
              name=value;
            });

            },
        ),


        SizedBox(height:0.9*SizeConfig.blockSizeVertical),

        TextFormField(
          style: TextStyle(
            color: Colors.white70,
            //TextFormField title background color change
          ),
          decoration: InputDecoration(labelText: ' Password',
              labelStyle: TextStyle(

                  color:  Colors.cyan[600]
              )
          ),
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (v){
            FocusScope.of(context).nextFocus(); // move focus to next
          },
          obscureText: true,
          autocorrect: true,
          validator: (value) {
            return value.length>=8?null:'Please create a 8 digit password';
            },
          onSaved: (value){
            setState(() {
              password=value;
            });

            },
        ),

        SizedBox(height:0.9*SizeConfig.blockSizeVertical),









          ]);
    }
  }



  Widget logo() {

    return Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Image.asset('images/mrec_logo.jpg'),
        radius: 17*SizeConfig.blockSizeHorizontal,
      ),
    );

  }



  Widget createButtons()
  {
   if (_formType==FormType.login)
     {
       return Column (
         crossAxisAlignment: CrossAxisAlignment.stretch,
           children : <Widget>[
         SizedBox(height:3.63*SizeConfig.blockSizeVertical),

         RaisedButton(
           child:Text('Log In',style :TextStyle(fontSize:4.72*SizeConfig.blockSizeHorizontal,color:Colors.white,fontFamily:'NunitoSans',letterSpacing: 0.5*SizeConfig.blockSizeHorizontal)),
           color:  Colors.cyan[600],
          // splashColor: Color(0XFF00857C).withBlue(2446).withOpacity(0.2),
           onPressed: validateAndSubmit,
           shape:  RoundedRectangleBorder(
               borderRadius: new BorderRadius.circular(5*SizeConfig.blockSizeVertical),
               side: BorderSide(color: Color(0XFF00857C).withBlue(2446).withOpacity(0.2),)
           ),

         ),

         FlatButton(
           child:Text("Don't have an acoount? Create one!",style :TextStyle(fontSize:3.3*SizeConfig.blockSizeHorizontal,color:Colors.blue)),
           onPressed: moveToRegister,
         ),
         SizedBox(height:36.363*SizeConfig.blockSizeVertical),
       ]);

     }
   else {
     return Column(
       crossAxisAlignment: CrossAxisAlignment.stretch,
         children: <Widget>[
       SizedBox(height:3.636*SizeConfig.blockSizeVertical),

       RaisedButton(
         child:Text('Create Acoount ',style :TextStyle(fontSize:3.88*SizeConfig.blockSizeHorizontal,color:Colors.white)),
         color:  Colors.cyan[600],
         onPressed: validateAndSubmit,
       ),

       FlatButton(
         child:Text("Already have an acccount Log in!",style :TextStyle(fontSize:3.33*SizeConfig.blockSizeHorizontal,color:Colors.blue)),

         onPressed: moveToLogin,
       ),
       SizedBox(height:45*SizeConfig.blockSizeVertical),
     ]);
   }
  }

}
