import 'package:flutter/material.dart';
import '../SizeConfig/Size.dart';
import '../Operations/ReadAndWriteFile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';


import 'Loading.dart';


class EditProfile extends StatefulWidget {
  String name,profileurl,email;
  final VoidCallback set;
  EditProfile({this.name,this.email,this.profileurl,this.set});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  final formKey= GlobalKey<FormState>();
  bool loading =false;

  String email="";
  File sampleImage;
  String name ="";

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
  void uploadImage(String Username) async{
    String _url;
    if(validateAndSave())
    {  if (sampleImage!=null){
      final StorageReference postImageRef= await FirebaseStorage.instance.ref().child("Profilepics");

      final StorageUploadTask uploadTask = await postImageRef.child(name+".jpg").putFile(sampleImage);
      var Imageurl = await (await uploadTask.onComplete).ref.getDownloadURL();
      _url = Imageurl.toString();}

    ReadAndWriteFile().editProfile(email,name,_url);
    setState(() {
      loading=false;
    });
    Navigator.of(context).pop();
    widget.set();
    print("Done");



    }
  }
  bool validateAndSubmit(){
    setState(() {
      loading=true;
    });
    uploadImage(name);

  }
  Future getImage()async{

    final tempimage =await ImagePicker().getImage(source:ImageSource.gallery,imageQuality: 30);
    setState(() {
      sampleImage=File(tempimage.path);
    });
  }
  @override
  Widget build(BuildContext context) {
    return loading?Loading():SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.black54,
        body:Padding(
          padding:  EdgeInsets.all(2*SizeConfig.blockSizeVertical),
          child: Form(
              key:formKey,
            child: ListView(
               // crossAxisAlignment: CrossAxisAlignment.stretch,
                children:<Widget>[

                  SizedBox(height: 5.45*SizeConfig.blockSizeVertical),

                  Text('Task ',textAlign: TextAlign.center,style: TextStyle(fontSize: 8.3*SizeConfig.blockSizeHorizontal,fontFamily:'NunitoSans',color:Colors.cyan[600]),),

                  SizedBox(height: 2.72*SizeConfig.blockSizeVertical),
                  FlatButton(
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 10*SizeConfig.blockSizeVertical,
                      backgroundImage:sampleImage==null? NetworkImage(widget.profileurl):FileImage(sampleImage),
                      //sampleImage==null? Image.asset('images/mrec_logo.jpg'):Image.file(sampleImage),
                    ),
                    onPressed: getImage,
                  ),
                  SizedBox(height: 2.72*SizeConfig.blockSizeVertical),
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
                    initialValue: widget.email,
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
                    initialValue: widget.name,
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



                  SizedBox(height:0.9*SizeConfig.blockSizeVertical),
                  SizedBox(height:3.636*SizeConfig.blockSizeVertical),

                  RaisedButton(
                    child:Text('Update Profile ',style :TextStyle(fontSize:3.88*SizeConfig.blockSizeHorizontal,color:Colors.white)),
                    color:  Colors.cyan[600],
                    onPressed: validateAndSubmit,
                  ),



                ]),
          ),
        ),
      ),
    );
  }
}
