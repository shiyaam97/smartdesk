import 'package:flutter/material.dart';

import '../DatabaseHelper/databasehelper.dart';
import '../model/nameandid.dart';
import '../model/settingmanager.dart';
import '../model/student.dart';
import '../screens/mainmenu.dart';

class allStudents extends StatefulWidget {
  const allStudents({Key? key}) : super(key: key);

  @override
  State<allStudents> createState() => _allStudentsState();
}

class _allStudentsState extends State<allStudents> {
  TextEditingController name = TextEditingController();
  int? uid;
  DatabaseHelper helper = DatabaseHelper.instance;
  Map<String,List<StudenNameID>> s1 = {};
  final _formKey = GlobalKey<FormState>();
  TimeOfDay selectedTime = TimeOfDay.now();
  @override
  Widget build(BuildContext context) {
    getAlldata();
    return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title:  Container(
                width: 400,
                decoration: const BoxDecoration(
                  color: Colors.white,
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
                            "All Students",

                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              SettingManager.mode =3;
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
                  TextFormField(
                    decoration: InputDecoration(
                      // isDense: true,

                      contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 1.0),
                      fillColor: Colors.white38,

                      // labelText: "Search Here...",
                      hintText: 'student name',
                      hintStyle: TextStyle(
                          fontSize: 12 ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),


                    ),
                    validator: (value) => value!.isEmpty
                        ? 'Please enter the student name'
                        : null,
                    maxLength: 10,
                    controller: name,
                  ),

                  SizedBox(
                    height: 250,
                    width: 350,
                    child: FutureBuilder<Map<String,List<StudenNameID>>>(
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
                                        'Class: $className',
                                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                      ),
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: students!.map((student) {
                                            return Padding(
                                              padding: const EdgeInsets.only(left: 10.0),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 150,
                                                    child: Text('${student.name}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        name.text = student.name;
                                                        uid = student.id;
                                                      });
                                                    },
                                                    icon: Icon(Icons.edit),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      uid = student.id;
                                                      helper.delete(uid!).then((value) {
                                                        setState(() {
                                                          print(value);
                                                        });
                                                      });
                                                    },
                                                    icon: Icon(Icons.delete),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return SizedBox.shrink(); // Return an empty widget if the index is out of bounds
                                }
                              },
                            ),
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
                            if (_formKey.currentState!.validate()) {
                              if(uid != null){
                                helper.updateColumnName(uid!, name.text).then((value) {
                                  showAlertDialogAdmin(   context,
                                      250,
                                      400,
                                      "Student Name Updated",
                                      'assets/icon/correct.png',
                                      true);


                                  setState(() {
                                    print(value);
                                  });

                                });
                              }else{
                                showAlertDialogAdmin(   context,
                                    250,
                                    400,
                                    "Please Select Student and Update ..",
                                    'assets/icon/warning.png',
                                    true);
                              }

                            }else{
                              showAlertDialogAdmin(   context,
                                  250,
                                  400,
                                  "Please Enter Student name",
                                  'assets/icon/warning.png',
                                  true);
                            }



                          }, child: Text('Update'.toUpperCase(),style: TextStyle(color: Colors.white),)),
                    ),
                  ),
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
                          onPressed: ()  {
                            name.clear();
                            setState(() {

                            });





                          }, child: Text('clear'.toUpperCase(),style: TextStyle(color: Colors.white),)),
                    ),
                  ),
                ],
              ),

            ],
          );
        }
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
        print(selectedTime);


      });
  }
  Future<Map<String,List<StudenNameID>>> getAlldata() async{
    Map<String,List<StudenNameID>> s1 = {};
    List<Map<String, dynamic>> test = [];
    test = await helper.queryAllRows();
    for (var item in test) {
      String classNum = item['class'];
      String name = item['name'];
      if(s1.containsKey(classNum)){
        s1[classNum]!.add(StudenNameID(id: item['id'],name: name));
      }else{
        s1[classNum] ??= [];
        s1[classNum]!.add(StudenNameID(id: item['id'],name: name));
      }



    }

    return s1;
  }

  void getAllMapData() async{
    List<Map<String, dynamic>> test = [];
    test = await helper.queryAllRows();
    for (var item in test) {
      String classNum = item['class'];
      String name = item['name'];
      if(s1.containsKey(classNum)){
        s1[classNum]!.add(StudenNameID(id: item['id'],name: name));
      }else{
        s1[classNum] ??= [];
        s1[classNum]!.add(StudenNameID(id: item['id'],name: name));
      }
  }
}}
