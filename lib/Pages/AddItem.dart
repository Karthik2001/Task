import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../SizeConfig/Size.dart';
import 'package:date_format/date_format.dart';
import '../Operations/ToDoTask.dart';
import '../Operations/ReadAndWriteFile.dart';
import 'Home.dart';
class AddItem extends StatefulWidget {
AddItem({this.set});
final VoidCallback set;
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final formKey= GlobalKey<FormState>();
  ReadAndWriteFile R =ReadAndWriteFile();
  String title,description,time;
  TextEditingController keyInputController = new TextEditingController();
  TextEditingController valueInputController = new TextEditingController();
  String _setTime;
  String _hour, _minute, _time;


  String dateTime;

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  int   _minutes=(DateTime.now().hour*60)+ DateTime.now().minute;


  TextEditingController _timeController = TextEditingController();
  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            primaryColor:  Colors.cyan,
            accentColor: Colors.cyan,


            colorScheme: ColorScheme.dark(primary:  Colors.cyan),
            dialogBackgroundColor: Colors.black,


            buttonTheme: ButtonThemeData(
                textTheme: ButtonTextTheme.accent
            ),
          ),
          child: child,
        );
      },
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _minutes = selectedTime.hour*60+selectedTime.minute;
        print(_minutes);
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }
  @override
  void initState(){

    print(_minutes);
    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    super.initState();

  }
  @override
  void dispose() {
    keyInputController.dispose();
    valueInputController.dispose();
    super.dispose();
  }

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



  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: true,
        backgroundColor:Colors.black54,
        appBar: AppBar(
          backgroundColor: Colors.black54,
          elevation: 0.1,
          centerTitle: true,
          leading:  IconButton(
            icon: Icon(Icons.chevron_left,
              color: Colors.cyan[600]
              ,size: 10.1*SizeConfig.blockSizeHorizontal,),
            color: Colors.white,
            onPressed:() {
              widget.set();
            },
          ),
          title: Text('Add To List',
              style: TextStyle(
                fontFamily: 'NunitoSans',

                fontSize: 8.33*SizeConfig.blockSizeHorizontal,
                color:  Colors.cyan[600],
              )
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.done,
                color: Colors.cyan[600]
                ,size: 8.1*SizeConfig.blockSizeHorizontal,),
              color: Colors.white,
              onPressed:() {
                if(validateAndSave())
                  {
                    ToDoTask T =ToDoTask(title,description,time,_minutes);
                    R.saveToDatabase(T);
                    Navigator.of(context).pop();
                    Navigator.of(context).push(new MaterialPageRoute(builder: (context)=>Home()));
                   print("yes");
                  }




              },
            ),
          ],

        ),

        body: Container(
          padding: EdgeInsets.all(7*SizeConfig.blockSizeHorizontal),
          child: Form(
            key:formKey,
            child: ListView(

              children: <Widget>[
                InkWell (
                  onTap: () {
                    _selectTime(context);
                  },
                  child: Container(

                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.cyan[600]),
                    child: TextFormField(
                      style: TextStyle(fontSize: 4.33*SizeConfig.blockSizeVertical,color: Colors.black54),

                      textAlign: TextAlign.center,
                      enabled: false,
                      keyboardType: TextInputType.text,
                      controller: _timeController,
                      onSaved: (String val) {
                        _setTime = val;
                        time= val;
                      },
                      decoration: InputDecoration(
                          disabledBorder:
                          UnderlineInputBorder(borderSide: BorderSide.none),
                          // labelText: 'Time',
                          contentPadding: EdgeInsets.only(top: 0.0)),
                    ),
                  ),
                ),
                TextFormField(
                  controller: keyInputController,
                  onFieldSubmitted: (v){
                    FocusScope.of(context).nextFocus(); // move focus to next
                  },
                  style: TextStyle(color: Colors.white70),
                  validator: (value){
                    return value.isEmpty?'Title is required':null;
                  },
                  onSaved: (value){
                    title=value;

                  },


                  maxLengthEnforced:false ,
// maxLines: 3,
                  autocorrect: true,
                  autofocus: true,
                  decoration: InputDecoration(labelText: ' Title',
                      labelStyle: TextStyle(

                          color:  Colors.cyan[600]
                      )
                  ),
                ),

                TextFormField(
                  controller: valueInputController,
                  style: TextStyle(color: Colors.white70),
                  validator: (value){
                    return value.isEmpty?'Description is required':null;
                  },
                  onSaved: (value){
                    description=value;

                  },
                  maxLines: 2,
                  textInputAction: TextInputAction.next,
                  maxLengthEnforced:true ,
                  onFieldSubmitted: (v){
                  // move focus to next
                  },

                  autocorrect: true,
                  autofocus: true,
                  decoration: InputDecoration(labelText: ' Description',
                      labelStyle: TextStyle(

                        color:  Colors.cyan[600],

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

