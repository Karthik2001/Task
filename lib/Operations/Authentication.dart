
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
// Initialize FlutterFir

abstract class AuthImplementation {
  Future<String> SignIn(String email,String password,String name);
  Future<User> SignUp(String email,String password,String name);
  Future<String> getCurrentUser();
  Future<void> signOut();
  Future<String> getCurrentUsername();



}

class Auth implements AuthImplementation{


  final FirebaseAuth _firebaseAuth= FirebaseAuth.instance;

  Future<String> SignIn(String email,String password,String name)async
  {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return user.uid;
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }


  Future<User> SignUp(String email,String password,String name)async
  {
    try {
      UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      User user = result.user;
      await user.sendEmailVerification();


      user.updateProfile(displayName: name);
      print(user.displayName);
      user.sendEmailVerification();


      return user;
    }
    catch(e){
      print (e.toString()+"this is error");
      return null;

    }
  }


  Future<String> getCurrentUser()async
  {
    User user = await _firebaseAuth.currentUser;
    if(user.uid!=null)
    return user.uid;
    else
      return null;

  }

  Future<String> getCurrentUsername()async
  {
    User user = await _firebaseAuth.currentUser;

    return user.displayName;
  }

  Future<void> signOut()async
  {
    _firebaseAuth.signOut();
  }
}