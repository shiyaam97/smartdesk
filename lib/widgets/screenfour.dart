import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../DatabaseHelper/databasehelper.dart';
import '../Functions/methods.dart';
import '../model/cleanUpTimer.dart';
import '../model/periods.dart';

import '../screens/mainmenu.dart';
import 'periodTable.dart';

class ScreenFour extends StatefulWidget {
  const ScreenFour({Key? key}) : super(key: key);

  @override
  State<ScreenFour> createState() => _ScreenFourState();
}

class _ScreenFourState extends State<ScreenFour> {
  Timer? timer1;
  String? coundownTimeR;
  String? estimatedTime;
  final _formKey = GlobalKey<FormState>();
  TextEditingController addMinutes = TextEditingController();
  TextEditingController controller1 = TextEditingController();
  TextEditingController min = TextEditingController();
  TextEditingController sec = TextEditingController();
  TextEditingController table = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  DatabaseHelper helper = DatabaseHelper.instance;
  List<Periods> table1 = [];
  List<Periods> table2 = [];

  String sendtime = DateFormat('hh:mm a').format(DateTime.now());
  TimeOfDay selectedTime = TimeOfDay.now();
  String? selectTable;
  DateTime? dt;
  List<String> classtables = ['Table 1', 'Table 2'];
  Map<String, List<Periods>> s1 = {};
  List<String> table_1_times = [
    '09:55 am',
    '10:58 am',
    '12:01 pm',
    '01:39 pm',
    '02:42 pm',
    '07:30 PM',
    '8:00 PM',
    '03:45 PM',
  ];
  Future<List<Periods>>? _periodsFuture;
  // Periods? selectedPeriod2;
  Periods? selectedPeriod1;
  int? reamindingTime;

  String? selectedItem;
  int? setminutes;
  String seconds = '';
  int selectedIndex = 0;
  int selectedIndex2 = 0;
  List<Periods> times = [];
  List<Periods> period = [
    Periods(tabletype: 'Table 1', period: 'Period 1', time: '09:55 AM'),
    Periods(tabletype: 'Table 1', period: 'Period 2', time: '10:58 AM'),
    Periods(tabletype: 'Table 1', period: 'Period 3', time: '12:01 PM'),
    Periods(tabletype: 'Table 1', period: 'Period 4', time: '01:39 PM'),
    Periods(tabletype: 'Table 1', period: 'Period 5', time: '02:42 PM'),
    Periods(tabletype: 'Table 1', period: 'Period 6', time: '03:45 PM'),
    Periods(tabletype: 'Table 1', period: 'Period 7', time: '00:00 AM'),
    Periods(tabletype: 'Table 2', period: 'Period 1', time: '09:35 AM'),
    Periods(tabletype: 'Table 2', period: 'Period 2', time: '10:20 AM'),
    Periods(tabletype: 'Table 2', period: 'Period 3', time: '11:05 AM'),
    Periods(tabletype: 'Table 2', period: 'Period 4', time: '12:25 PM'),
    Periods(tabletype: 'Table 2', period: 'Period 5', time: '01:10 PM'),
    Periods(tabletype: 'Table 2', period: 'Period 6', time: '02:30 PM'),
    Periods(tabletype: 'Table 2', period: 'Period 7', time: '00:00 AM'),
  ];
  bool check = false;

  String selectedRadio = 'Table 1';

  void handleRadioValueChange(String value) {
    setState(() {
      selectedIndex2 = 0;
      selectedIndex = 0;

      selectedRadio = value;
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
        dt = DateTime(
          picked.hour,
          picked.minute,
        );
        print(dt.toString());
      });
  }
  void onAlertBoxClosed() {
    // Rebuild the widget
    setState(() {});
  }
  @override
  void initState() {
    addperiods();
    _periodsFuture = getTable1();
 /*   Future.delayed(Duration(seconds: 1), () {
      print('Delayed operation executed');
    });*/
    check = false;
    getAlldata();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 650,
      child: !check
          ? CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Table',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: RadioListTile(
                          activeColor: Colors.black,
                          value: 'Table 1',
                          groupValue: selectedRadio,
                          title: Text(
                            'Table 1',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          onChanged: (va) {
                            handleRadioValueChange(va!);
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: RadioListTile(
                        activeColor: Colors.black,
                        value: 'Table 2',
                        groupValue: selectedRadio,
                        title: Text(
                          'Table 2',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        onChanged: (va) {
                          handleRadioValueChange(va!);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),

                Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 250,
                      child: Text('Select your class period :',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          )),
                    ),
                    if (selectedRadio == 'Table 1')
                      StatefulBuilder(
                          builder: (context, setState) {
                          return FutureBuilder<List<Periods>>(

                            future:  getTable1(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData) {
                                return Center(child: Text('No data available.'));
                              } else{

                                List<Periods> items = snapshot.data!;
                                Periods? selectedPeriod = items[selectedIndex];
                                selectedPeriod1 = items[selectedIndex];

                                return  Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2<Periods>(
                                      isExpanded: true,
                                      hint: const Row(
                                        children: [

                                          Expanded(
                                            child: Text(
                                              'Select Time',
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
                                      items:  items.map((period) {
                                        return DropdownMenuItem<Periods>(
                                          value: period,
                                          child:
                                          Text('${period.period} - ${period.time}',style: TextStyle(color: Colors.white),),
                                        );
                                      }).toList(),
                                      value: selectedPeriod,
                                      onChanged: (Periods? newValue) {
                                        setState(() {
                                          selectedIndex = items.indexOf(newValue!);
                                          selectedPeriod1 = newValue;

                                        });
                                      },
                                      buttonStyleData: ButtonStyleData(
                                        height: 50,
                                        width: 200,
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
                                        maxHeight: 250,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(14),
                                          color: Colors.black,
                                        ),
                                        // offset: const Offset(-20, 0),
                                        scrollbarTheme: ScrollbarThemeData(
                                          radius: const Radius.circular(40),
                                          thickness: MaterialStateProperty.all(6),
                                          thumbVisibility: MaterialStateProperty.all(true),
                                        ),
                                      ),
                                      menuItemStyleData: const MenuItemStyleData(
                                        height: 40,
                                        padding: EdgeInsets.only(left: 14, right: 14),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              // Convert map keys to a list for easy access




                            },

                          );
                        }
                      ),

                    if (selectedRadio == 'Table 2')
                      StatefulBuilder(
                          builder: (context, setState) {
                            return FutureBuilder<List<Periods>>(

                              future:  getTable2(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData) {
                                  return Center(child: Text('No data available.'));
                                } else{

                                  List<Periods> items = snapshot.data!;
                                  Periods? selectedPeriod = items[selectedIndex2];
                                  selectedPeriod1 = items[selectedIndex2];

                                  return  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton2<Periods>(
                                        isExpanded: true,
                                        hint: const Row(
                                          children: [

                                            Expanded(
                                              child: Text(
                                                'Select Time',
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
                                        items:  items.map((period) {
                                          return DropdownMenuItem<Periods>(
                                            value: period,
                                            child:
                                            Text('${period.period} - ${period.time}',style: TextStyle(color: Colors.white),),
                                          );
                                        }).toList(),
                                        value: selectedPeriod,
                                        onChanged: (Periods? newValue) {
                                          setState(() {
                                            selectedIndex2 = items.indexOf(newValue!);
                                            selectedPeriod1 = newValue;

                                          });
                                        },
                                        buttonStyleData: ButtonStyleData(
                                          height: 50,
                                          width: 200,
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
                                          maxHeight: 250,
                                          width: 200,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(14),
                                            color: Colors.black,
                                          ),
                                          // offset: const Offset(-20, 0),
                                          scrollbarTheme: ScrollbarThemeData(
                                            radius: const Radius.circular(40),
                                            thickness: MaterialStateProperty.all(6),
                                            thumbVisibility: MaterialStateProperty.all(true),
                                          ),
                                        ),
                                        menuItemStyleData: const MenuItemStyleData(
                                          height: 40,
                                          padding: EdgeInsets.only(left: 14, right: 14),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                // Convert map keys to a list for easy access




                              },

                            );
                          }
                      ),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 250,
                        child: Text('Set Countdown time:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ))),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SizedBox(
                        height: 50,
                        width: 70,
                        child: TextFormField(
                          autofocus: true,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                            controller: min,
                            maxLength: 2,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                setminutes = int.parse(value!);
                              });
                            },
                          decoration: InputDecoration(
                            counterText: '',

                            // isDense: true,

                            // contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 1.0),
                            filled: true,
                            fillColor: Colors.black,

                            // labelText: "Search Here...",
                            hintText: '',

                            hintStyle: TextStyle(
                                fontSize: 12 ,color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),

                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),

                            ),


                          ),),
                      ),
                    ),
                    Text('MINUTES',style: TextStyle(fontSize: 16),),

                  ],
                ),
                if(estimatedTime != null && coundownTimeR == null)
                Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 250,
                        child: Text('Estimated Time:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ))),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: 50,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(child: Text('${estimatedTime!} MINUTES',style: TextStyle(color: Colors.white,fontSize: 16),))),
                    ),


                  ],
                ),
                if(coundownTimeR != null)...[
                  SizedBox(
                    height: 30,
                  ),
                  Text(coundownTimeR!,style: TextStyle(fontSize: 50,fontWeight: FontWeight.w700),),
                ],

                SizedBox(
                  height: 70,
                ),
                SizedBox(
                  height: 48,
                  width: 220,
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          // Adjust the radius as needed
                          side: BorderSide(
                              color: Colors.black,
                              width: 1.0), // Border color and width
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AllTables();
                          },
                        );
                      },
                      label: Text('View Period'),
                      icon: Icon(Icons.edit)),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 45,
                  width: 240,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () {
                        if(selectedPeriod1 == null){
                          showAlertDialogAdmin(   context,
                              250,
                              400,
                              "Please Select Time again",
                              'assets/icon/warning.png',
                              true);
                        }else if(setminutes == null){
                          showAlertDialogAdmin(   context,
                              250,
                              400,
                              "Count Down Timer is Empty",
                              'assets/icon/warning.png',
                              true);

                        }else{
                          String givenTime = selectedPeriod1!.time.toString();
                          // String givenTime = '12:05 AM';
                          DateTime givenDateTime = DateFormat('h:mm a').parse(givenTime);
                          String t1 = DateFormat('hh:mm a').format(DateTime.now());
                          DateTime currentDateTime = DateFormat('h:mm a').parse(t1);
                          Duration timeDifference = givenDateTime.difference(currentDateTime);
                          int minutesDifference = timeDifference.inMinutes;


                          print('$minutesDifference minutes');
                            int printmint = minutesDifference - setminutes!;
                            if(printmint > 0){
                              print('$printmint printmint');

                              sendReading('${printmint.toString().padLeft(2, '0')} MINUTES');
                              if(timer1 != null){
                                timer1!.cancel();
                              }
                              coundownTime(printmint);
                              setState(() {
                                coundownTimeR = '${printmint.toString().padLeft(2, '0')}  MINUTES';
                              });
                            }else{
                              showAlertDialogAdmin(context,
                                  250,
                                  400,
                                  "Please Select Correct Period Time..",
                                  'assets/icon/warning.png',
                                  true);
                            }



                        }


                      },
                      child: Text(
                        'Send',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ],
            ),
    );
  }

  void coundownTime(int countdownMinutes){
    // Start the countdown timer
    timer1 = Timer.periodic(Duration(minutes: 1), (timer) {
      if (countdownMinutes > 0) {
        countdownMinutes--;
        if(countdownMinutes == 0){
          sendReading('Time is up');
          coundownTimeR = null;
          setState(() {

          });

          // Stop the timer when the countdown is complete

        }else{
          sendReading('${countdownMinutes.toString().padLeft(2, '0')} MINUTES');
          setState(() {
            coundownTimeR = '${countdownMinutes.toString().padLeft(2, '0')} MINUTES';


          });
        }

      } else{
        timer.cancel();
        timer1!.cancel();

      }
    });
  }

  Future<List<Periods>> getTable1() async {
    List<Periods> table1 = [];
    List<Map<String, dynamic>> test = [];
    test = await helper.queryAllRowsPeriod();
    for (var item in test) {
      if (item['tabletype'] == 'Table 1') {

        table1.add(Periods(
            id: item['id'],
            tabletype: item['tabletype'],
            period: item['period'],
            time: item['time']));
      }
    }

    return table1;
    // Fetch data from your database or data source
    // For example, using an HTTP request or database query
    // Return the list of items you want to display in the dropdown.
  }
  Future<List<Periods>> getTable2() async {
    List<Periods> table2 = [];
    List<Map<String, dynamic>> test = [];
    test = await helper.queryAllRowsPeriod();
    for (var item in test) {
      if (item['tabletype'] == 'Table 2') {

        table2.add(Periods(
            id: item['id'],
            tabletype: item['tabletype'],
            period: item['period'],
            time: item['time']));
      }
    }

    return table2;
    // Fetch data from your database or data source
    // For example, using an HTTP request or database query
    // Return the list of items you want to display in the dropdown.
  }

  void addperiods() async {
    List<Map<String, dynamic>> test = [];
    test = await helper.queryAllRowsPeriod();
    if (test.isEmpty || test == null) {
      for (Periods p in period) {
        Periods per =
            Periods(tabletype: p.tabletype, period: p.period, time: p.time);
        int studentId = await helper.insertPeriod(per.toMap());
        print(p.time);
      }
    }
  }

  Future<Map<String, List<Periods>>> getAlldata() async {
    List<Map<String, dynamic>> test = [];
    test = await helper.queryAllRowsPeriod();
    for (var item in test) {
      if (item['tabletype'] == 'Table 1') {
        table1.add(Periods(
            id: item['id'],
            tabletype: item['tabletype'],
            period: item['period'],
            time: item['time']));
      } else {
        table2.add(Periods(
            tabletype: item['tabletype'],
            period: item['period'],
            time: item['time']));
      }
    }
    setState(() {
      check = true;
    });

    return s1;
  }
  @override
  void dispose() {
    if(timer1 != null)
      timer1!.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  void _updateTime(Timer timer) {
    if (reamindingTime! > 0) {
      reamindingTime = reamindingTime! - 1;
      sendReading('  ${reamindingTime!.toString()} : 00 ');
      setState(() {


      });
    }

  }
}
