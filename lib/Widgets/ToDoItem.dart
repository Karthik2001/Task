import 'package:flutter/material.dart';
import '../SizeConfig/Size.dart';
import 'Options.dart';
import '../Operations/ReadAndWriteFile.dart';
class ToDoItem extends StatefulWidget {
  String name,description,time,tid;
  final VoidCallback set;
  ToDoItem(this.tid,this.name,this.description,this.time,this.set);
  @override
  _ToDoItemState createState() => _ToDoItemState();
}

class _ToDoItemState extends State<ToDoItem> {
  Options op;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 2*SizeConfig.blockSizeVertical,left:2*SizeConfig.blockSizeHorizontal,right: 2*SizeConfig.blockSizeHorizontal),
      height: 15*SizeConfig.blockSizeVertical,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(1.68*SizeConfig.blockSizeVertical),
            topRight:Radius.circular(1.68*SizeConfig.blockSizeVertical),
            bottomLeft: Radius.circular(1.68*SizeConfig.blockSizeVertical),
            bottomRight: Radius.circular(1.68*SizeConfig.blockSizeVertical)
        ),
        color: Colors.white10

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[

                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 2.7*SizeConfig.blockSizeHorizontal,top: 7.5,right: 1.94*SizeConfig.blockSizeHorizontal,bottom: 1.8*SizeConfig.blockSizeVertical),
                      child: CircleAvatar(
                        //backgroundImage: NetworkImage(url),
                        radius : 0.9*SizeConfig.blockSizeVertical ,
                        backgroundColor: Colors.cyan[600],
                      ),
                    ),
                  ),

                  Text(widget.name,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 5.8*SizeConfig.blockSizeHorizontal,
                        //fontWeight: FontWeight.w700, fontFamily: 'NunitoSans',
                        //fontFamily:'Courgette',
                        color:Colors.white70),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(widget.time,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'NunitoSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 4.33*SizeConfig.blockSizeHorizontal,
                        color:  Colors.cyan[600],
                      )
                  ),
                  IconButton(
                    icon: Icon(Icons.access_time,
                      color: Colors.cyan[600]
                      ,size: 6.1*SizeConfig.blockSizeHorizontal,),
                    color: Colors.white,
                    onPressed:() {

                    },
                  ),


                  IconButton(
                    icon: Icon(Icons.delete,
                      color: Colors.cyan[600]
                      ,size: 6.1*SizeConfig.blockSizeHorizontal,),
                    color: Colors.white,
                   onPressed: (){
                      ReadAndWriteFile().deletefromDatabase(widget.tid ,widget.set);
                      widget.set();
                   },
                  ),
                ],
              ),

            ],
          ),
          Padding(
            padding:  EdgeInsets.fromLTRB(3.88*SizeConfig.blockSizeHorizontal, 1.45*SizeConfig.blockSizeVertical, 2.22*SizeConfig.blockSizeHorizontal,1.45*SizeConfig.blockSizeVertical ),
            child: Text(widget.description,
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: 4.1*SizeConfig.blockSizeHorizontal,
                  //fontWeight: FontWeight.w700, fontFamily: 'NunitoSans',
                  //fontFamily:'Courgette',
                  color:Colors.white70),
            ),
          ),
        ],

      ),
    );
  }
}
