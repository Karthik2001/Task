import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import'../SizeConfig/Size.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color:Colors.black54,
      child:SpinKitRing(
        color:Colors.cyan[600],
        size: 10*SizeConfig.blockSizeVertical,
      )
    );
  }
}
