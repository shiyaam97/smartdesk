import 'package:flutter_libserialport/flutter_libserialport.dart';

class SettingManager {
  static String phValue = "";
  static int baudRate = 115200;
  static int bits = 8;
  static int stopBits = SerialPortParity.none;
  static String? serialPort;
  static int flowControl = SerialPortFlowControl.xonXoff;
  static int parity = SerialPortParity.none;

  static bool status = false;
  static bool reading = false;
  static var port;

  static String readtingType = "pH";
  static String caliDetails = "Not Calibrated";
  static int radioButton = 2;
  static bool calibrate = false;
  static String moduleOutput = '';
  static List<String> cali = [];
  static int mode = 1;
}
