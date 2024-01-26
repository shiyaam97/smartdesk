import 'dart:convert';
import 'dart:typed_data';

import 'package:intl/intl.dart';

import '../model/settingmanager.dart';

void sendReading(String message) async {
  print(message);
  SettingManager.port.writeBytesFromString(message);
}
enum ScreenOneMode { time, date }

String getTimeFormate(String time){

  DateFormat format = DateFormat('h:mm a');
  DateTime givenDateTime = format.parse(time);

  return givenDateTime.toString();
}