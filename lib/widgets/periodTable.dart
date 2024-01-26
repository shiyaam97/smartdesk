import 'package:flutter/material.dart';

import '../DatabaseHelper/databasehelper.dart';
import '../model/nameandid.dart';
import '../model/periods.dart';
import '../model/settingmanager.dart';
import '../screens/mainmenu.dart';

class AllTables extends StatefulWidget {

  const AllTables({Key? key}) : super(key: key);

  @override
  State<AllTables> createState() => _AllTablesState();
}

class _AllTablesState extends State<AllTables> {
  int? uid;
  TimeOfDay selectedTime = TimeOfDay.now();
  DatabaseHelper helper = DatabaseHelper.instance;
  Map<String,List<Periods>> p1 = {};
  final _formKey = GlobalKey<FormState>();
  TextEditingController time = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title:  Container(
                width: 250,
                decoration: const BoxDecoration(
                  // color: Color.fromARGB(255, 5, 61, 124),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "All Periods",

                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              SettingManager.mode =4;
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MainMenu(),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.close,
                              size: 20,
                            ))
                      ],
                    ),
                    Divider(
                      thickness: 1,
                    ),
                  ],
                )),
            titlePadding: const EdgeInsets.all(0),
            content: Form(
              key: _formKey,
              child: Column(


                children: [


                  SizedBox(
                    height: 300,
                    width: 350,
                    child: FutureBuilder<Map<String,List<Periods>>>(
                      future: getAlldata(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData) {
                          return Center(child: Text('No data available.'));
                        } else{
                          final data = snapshot.data;
                          final classKeys = data!.keys.toList();
                          classKeys.sort((a, b) => a.compareTo(b));
                          return Scrollbar(
                            isAlwaysShown: true,
                            child: ListView.builder(
                              itemCount: classKeys.length,
                              itemBuilder: (context, index) {
                                if (index >= 0 && index < classKeys.length) {
                                  final className = classKeys[index];
                                  final students = data[className];

                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(color: Colors.black, width: 1.0), // Border color and width
                                      borderRadius: BorderRadius.circular(10.0), // Border radius
                                    ),
                                    child: ExpansionTile(
                                      collapsedTextColor: Colors.black,
                                      textColor: Colors.black,
                                      backgroundColor: Colors.black12,
                                      title: Text(
                                        '$className',
                                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                      ),

                                      children: students!.map((student) {
                                        return ListTile(
                                          title: Text('${student.period}  ${student.time}'),
                                          trailing: IconButton(
                                            onPressed: () {
                                              uid = student.id;
                                              _selectTime(context, uid!);
                                            },
                                            icon: Icon(Icons.edit),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  );
                                } else {
                                  return SizedBox.shrink();
                                }
                              },
                            )

                          );
                        }
                        // Convert map keys to a list for easy access




                      },

                    ),
                  ),

                ],
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 40,
                      width: 120,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            SettingManager.mode =4;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MainMenu(),
                              ),
                            );



                          }, child: Text('Close'.toUpperCase(),style: TextStyle(color: Colors.white),)),
                    ),
                  ),
                ],
              ),

            ],
          );
        }
    );
  }

  Future<Map<String,List<Periods>>> getAlldata() async{
    Map<String,List<Periods>> s1 = {};
    List<Map<String, dynamic>> test = [];
    test = await helper.queryAllRowsPeriod();
    for (var item in test) {
      String classNum = item['tabletype'];
      // String name = item['name'];
      if(s1.containsKey(classNum)){

        s1[classNum]!.add(Periods(id: item['id'],tabletype: item['tabletype'],period: item['period'],time: item['time']));
      }else{
        s1[classNum] ??= [];
        s1[classNum]!.add(Periods(id: item['id'],tabletype: item['tabletype'],period: item['period'],time: item['time']));
      }



    }

    return s1;
  }
  Future<void> _selectTime(BuildContext context,int id) async {
    String? time;
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null && picked != selectedTime)

      setState(() {
        final hour = picked.hourOfPeriod;
        final minute = picked.minute;
        final period = picked.period == DayPeriod.am ? 'AM' : 'PM';
        final formattedMinute = minute.toString().padLeft(2, '0');
        time = '$hour:$formattedMinute $period';
        selectedTime = picked;
        helper.updatePeriodtime(id!,time!).then((value) {

setState(() {

});


        });
        // selectedTime = DateTime(picked)
        // selectTime = '$hour:$minute $period';
        print(selectedTime);


      });
  }
}
