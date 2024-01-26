import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/services.dart';
import 'package:serial_port_win32/serial_port_win32.dart';

// import 'package:dart_serial_port/dart_serial_port.dart';
// import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter/material.dart';
import 'package:smartdesk/screens/mainmenu.dart';
import 'model/settingmanager.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  // in connecting all ports in Pc
  List<String> allports = [];
  // droupDown selection port
  String? selectedItem;

  @override
  void initState() {
    super.initState();
    getAllPorts();

  }

  @override
  void dispose() {

    super.dispose();
  }

  void getAllPorts() async{
    final ports = await SerialPort.getAvailablePorts();
    setState(() {
      allports = ports;
    });



  }
  //Move to main menu screen
  void check(value) async{
    SettingManager.port = SerialPort(value, openNow: false, ByteSize: 8, ReadIntervalTimeout: 1, ReadTotalTimeoutConstant: 2,BaudRate: 115200);
    print(SettingManager.port);
    try {
      SettingManager.port.openWithSettings(BaudRate: 115200);
    } catch (e, s) {
      SettingManager.port.cancel();
      showAlertDialog(
          context,
          216,
          380,
          "Select correct port and try again",
          'assets/warning.png',
          true);

      print(s);
      print(e);

    }
    SettingManager.port.readBytesSize = 8;
    String buffer = "4870";
    SettingManager.port.writeBytesFromString(buffer);
    var test = await SettingManager.port.readBytesUntil(Uint8List.fromList("\n".codeUnits));
    print(test);
    String s = new String.fromCharCodes(test);
    print(s);
    if(s.length > 5){
      // navigate the main screen
      // SettingManager.port.writeBytesFromString('hi');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainMenu()));
    }else{
      print('test-----');
    }


  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // splach gif
          Center(
            child: Image.asset(
              'assets/images/animated/split flap.gif', // Replace with the actual path to your GIF
              width: 400.0, // Adjust the width as needed
              height: 200.0, // Adjust the height as needed
            ),
          ),
          SizedBox(height: 30,),
          // of port length more the 0 its will show
          Center(
            child:allports.length > 0?
            DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: const Row(
                  children: [
                    /* Icon(
                          Icons.list,
                          size: 16,
                          color: Colors.yellow,
                        ),*/
                    /*  SizedBox(
                          width: 4,
                        ),*/
                    Expanded(
                      child: Text(
                        'Select Port',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                items: allports
                    .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
                    .toList(),
                value: selectedItem,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedItem = newValue;
                    print(selectedItem);
                  });
                },
                buttonStyleData: ButtonStyleData(
                  height: 50,
                  width: 150,
                  padding: const EdgeInsets.only(left: 12, right: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.black26,
                    ),
                    color: Colors.black,
                  ),
                  elevation: 2,
                ),
                iconStyleData: const IconStyleData(
                  icon: Icon(
                    Icons.arrow_drop_down_outlined,
                  ),
                  iconSize: 25,
                  iconEnabledColor: Colors.white,
                  iconDisabledColor: Colors.white,
                ),
                dropdownStyleData: DropdownStyleData(

                  maxHeight: 200,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.black,
                  ),
                  // offset: const Offset(-20, 0),
                  scrollbarTheme: ScrollbarThemeData(
                    radius: const Radius.circular(40),
                    thickness: MaterialStateProperty.all(6),
                    thumbColor: MaterialStateProperty.all(Colors.white),
                    thumbVisibility: MaterialStateProperty.all(true),
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                  padding: EdgeInsets.only(left: 14, right: 14),
                ),
              ),
            ):Text('no ports available')
            ,

          ),
          SizedBox(height: 30,),
          // connect button
          SizedBox(
            height: 45,
            width: 180,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: (){

              if(selectedItem != null)
                check(selectedItem);
            }, child: Text('Connect',style: TextStyle(color: Colors.white),)),
          )
        ],
      ),
    );
  }
}

// alert box
showAlertDialog(BuildContext context, double height, double width,
    String message, String Icon, bool btn) {
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: SizedBox(
            height: height,
            width: width,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Image.asset(
                      Icon,
                      height: 52,
                      width: 58,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      message,
                      style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(153, 1, 1, 1),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Jost'),
                    ),
                  ),
                  if (btn)
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: SizedBox(
                        width: 92,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              Color.fromARGB(255, 5, 61, 124),
                              // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Ok",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  fontFamily: 'Jost',
                                  color:
                                  Color.fromARGB(255, 234, 240, 248)),
                            )),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      });
    },
  );
}