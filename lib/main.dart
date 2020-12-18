import 'package:flutter/material.dart';
import 'Pages/Feeds.dart';
import 'SizeConfig/Size.dart';
import 'package:flutter/services.dart';
import 'Pages/Home.dart';
import 'Mapping.dart';

import 'package:firebase_core/firebase_core.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Myapp());
}
class Myapp extends StatefulWidget {
  @override
  _MyappState createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return LayoutBuilder(
      // Initialize FlutterFire

        builder: (context,constraints){

          return OrientationBuilder(
              builder: (context,orientation){
                SizeConfig().init(constraints, orientation);
                return  MaterialApp(
                    color: Colors.cyan[600],
                    title: 'Task',
                    debugShowCheckedModeBanner: false,
                    home :  MappingPage(),
                   routes:{'/home': (context)=>MappingPage(),}
                );
              }
          );
        }
    );
  }
}

