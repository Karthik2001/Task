import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class StoreUser {
  String name;
  StoreUser(String name){
    this.name =name;
  }

Future<String>  storeUserDetails(User  user ,String email, String name  )
 async {
   var data={
     'email':user.email,
     'uid':user.uid,
     'name':name.substring(0,1).toUpperCase()+ name.substring(1),
     'searchKey': name.substring(0,1).toUpperCase(),

   };

   try{ FirebaseFirestore.instance.collection('/userDetails').doc(name).set(data);
   return user.uid;
   }
   catch(e)
   {
     return null;
   }
 }
}