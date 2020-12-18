import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../SizeConfig/Size.dart';

class Options{

  options(BuildContext context) {
    return showDialog(context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            backgroundColor: Colors.black54,
            children: <Widget>[

              SimpleDialogOption(
                onPressed: () {},
                child: Text("Mark as Complete",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'NunitoSans',
                      fontSize: 5.33*SizeConfig.blockSizeHorizontal,
                      color:  Colors.cyan[600],
                      fontWeight: FontWeight.bold,
                    )
                ),
              ),


              SimpleDialogOption(
                onPressed: () {},
                child: Text("Delete",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'NunitoSans',
                      fontSize: 5.33*SizeConfig.blockSizeHorizontal,
                      color:  Colors.cyan[600],
                      fontWeight: FontWeight.bold,
                    )
                ),
              ),


              SimpleDialogOption(
                onPressed: () {},
                child: Text("Postpone",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'NunitoSans',
                      fontSize: 5.33*SizeConfig.blockSizeHorizontal,
                      color:  Colors.cyan[600],
                      fontWeight: FontWeight.bold,
                    )
                ),
              ),

            ],
          );
        });
  }
}