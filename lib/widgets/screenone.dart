import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Functions/methods.dart';
import '../styles.dart';

class ScreenOne extends StatefulWidget {
  const ScreenOne({Key? key}) : super(key: key);

  @override
  State<ScreenOne> createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {

  String selectedRadio = 'Time';
  bool checkSetState = true;
  // DateTime now = DateTime.now();
  String formattedTime = DateFormat('hh:mm a').format(DateTime.now());
  String sendtime = DateFormat('hh:mm a').format(DateTime.now());
  String  formattedDate = DateFormat('EEE MMM dd').format(DateTime.now()).toUpperCase();



  String? selectedOption;
  Timer? timer;

  void startTimer() {
    // Cancel the previous timer
    timer?.cancel();


  }
  @override
  void initState() {
    super.initState();
    checkSetState = true;
    sendReading(sendtime);
    // Set up a timer to update the time every second
    Timer.periodic(Duration(seconds: 1), _updateTime);
  }
  @override
  void dispose() {
    checkSetState = false;

    timer?.cancel();
    super.dispose();
  }

  void _updateTime(Timer timer) {
    if(checkSetState){
      setState(() {
        formattedDate = DateFormat('EEE MMM dd').format(DateTime.now()).toUpperCase();
        formattedTime = DateFormat('hh:mm a').format(DateTime.now());

      });
    }

    bool isBefore = isTime1BeforeTime2(sendtime, formattedTime);
    if(isBefore){
      if(_selectedValue == 1){
        sendReading(formattedTime);
      }

      sendtime = formattedTime;
    }
  }
  int _selectedValue = 1; // Index of the selected checkbox

  void _handleCheckboxValueChanged(int value) {
    if(checkSetState){
      setState(() {
        _selectedValue = value;
      });
    }

    if(_selectedValue == 2){
      sendReading(formattedDate!);
    }else{
      sendReading(formattedTime!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 650,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[


          SizedBox(
            width: 310,
            child:Transform.scale(
              scale: 1.5,
              child: CheckboxListTile(
                activeColor: Colors.black,
                title: Center(child: Text(formattedTime!,style: SmartStyle.TimeStyle())),
                value: _selectedValue == 1,
                onChanged: (newValue) {
                  _handleCheckboxValueChanged(1);
                },
              ),
            ),
          ),
          SizedBox(height: 30,),
          SizedBox(
            width: 310,
            child: Transform.scale(
              scale: 1.5,
              child: CheckboxListTile(
                activeColor: Colors.black,
                title: Center(child: Text(formattedDate!,style: SmartStyle.DateStyle(),)),
                value: _selectedValue == 2,
                onChanged: (newValue) {
                  _handleCheckboxValueChanged(2);
                },
              ),
            ),
          ),

        ],
      ),
    );
  }

  handleRadioValueChanged(String? value) {
    if(checkSetState){
      setState(() {
        selectedRadio = value!;
      });
    }

    startTimer();
  }

  bool isTime1BeforeTime2(String time1, String time2) {
    // Define the time format
    final timeFormat = DateFormat('hh:mm a');

    // Parse the times into DateTime objects
    DateTime dateTime1 = timeFormat.parse(time1);
    DateTime dateTime2 = timeFormat.parse(time2);

    // Compare the times
    return dateTime1.isBefore(dateTime2);
  }
}
