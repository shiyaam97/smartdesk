import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smartdesk/model/settingmanager.dart';

import '../widgets/IconButton.dart';
import '../widgets/Iconbutton2.dart';
import '../widgets/screenfour.dart';
import '../widgets/screenone.dart';
import '../widgets/screenthree.dart';
import '../widgets/screentwo.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: 850,
        child: Row(
          children: [
            // here is button of first screen
            SizedBox(
              width: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                // mode 1 button
                  SettingManager.mode == 1
                      ? CusTomIconButton(onPressed: (){
                    setState(() {
                      SettingManager.mode = 1;
                    });
                  },iconPath: 'assets/svg/dateandtime.svg',)
                      : IconButton2(onPressed: (){
                    setState(() {
                      SettingManager.mode = 1;
                    });
                  },iconPath: 'assets/svg/dateandtime.svg',),
                  // mode 2 button
                  SettingManager.mode == 2
                      ? CusTomIconButton(onPressed: (){
                    setState(() {
                      SettingManager.mode = 2;
                    });
                  },iconPath: 'assets/svg/Icon.svg',)
                      : IconButton2(onPressed: (){
                    setState(() {
                      SettingManager.mode = 2;
                    });
                  },iconPath: 'assets/svg/Icon.svg',),
                  // mode 3 button
                  SettingManager.mode == 3
                      ?CusTomIconButton(onPressed: (){
                    setState(() {
                      SettingManager.mode = 3;
                    });
                  },iconPath: 'assets/svg/random.svg',)

                      : IconButton2(onPressed: (){
                    setState(() {
                      SettingManager.mode = 3;
                    });
                  },iconPath: 'assets/svg/random.svg',),
                  // mode 4 button
                  SettingManager.mode == 4
                      ? CusTomIconButton(onPressed: (){
                    setState(() {
                      SettingManager.mode = 4;
                    });
                  },iconPath: 'assets/svg/timer.svg',)
                      : IconButton2(onPressed: (){
                    setState(() {
                      SettingManager.mode = 4;
                    });
                  },iconPath: 'assets/svg/timer.svg',),


                ],
              ),
            ),
            VerticalDivider(
              color: Colors.black,
              thickness: 2,
            ),
            SettingManager.mode == 1
                ? ScreenOne()
                : SettingManager.mode == 2
                    ? ScreenTwo()
                    : SettingManager.mode == 3
                        ? Screenthree()
                        : ScreenFour()
          ],
        ),
      ),
    );
  }
}
showAlertDialogAdmin(BuildContext context, double height, double width,
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
                      height: 80,
                      width: 80,
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      message,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Jost'),
                    ),
                  ),
                  SizedBox(height: 20,),
                  if (btn)
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: SizedBox(
                        width: 100,
                        height: 45,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onPressed: () {

                              Navigator.pop(context);
                            },
                            child: Text(
                              "OK",
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