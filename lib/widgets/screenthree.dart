import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../DatabaseHelper/databasehelper.dart';
import '../Functions/methods.dart';
import '../model/nameandid.dart';
import '../model/settingmanager.dart';
import '../model/student.dart';
import '../screens/mainmenu.dart';
import 'addstudents.dart';

class Screenthree extends StatefulWidget {
  const Screenthree({Key? key}) : super(key: key);

  @override
  State<Screenthree> createState() => _ScreenthreeState();
}

class _ScreenthreeState extends State<Screenthree> {
  List<Student> students = [];
  String? selectedItem;
  List<String> classRomms = [];
  String student = '';
  TextEditingController controller1  = TextEditingController();
  TextEditingController controller2  = TextEditingController();
  DatabaseHelper helper = DatabaseHelper.instance;
  final _formKey = GlobalKey<FormState>();
  Map<String,List<StudenNameID>> s1 = {};


  @override
  void initState() {
    getAlldata();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
        width: 650,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          if(classRomms.length > 0)...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Select your class : ',  style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonHideUnderline(
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
                              'Select Class',
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
                      items: classRomms
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
                          student = '';
                          print(selectedItem);
                        });
                      },
                      buttonStyleData: ButtonStyleData(
                        height: 50,
                        width: 120,
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
                        width: 100,
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
                )]),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 45,
                width: 250,
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    onPressed: (){

                      setState(() async {
                        if(selectedItem == null){
                          showAlertDialogAdmin(   context,
                              250,
                              400,
                              "Please Select Class",
                              'assets/icon/warning.png',
                              true);
                        }else{
                          student = getRandomValue(selectedItem!.toString());
                          sendReading('');
                          await Future.delayed(Duration(seconds: 4));
                          sendReading(student);
                        }

                        // sendReading(student);
                      });
                    }, icon: SvgPicture.asset('assets/svg/random.svg',
                    color: Colors.white,
                    width: 20, // Set the desired width
                    height: 20) , label: Text('Select Random Student',style: TextStyle(color: Colors.white),)),
              ),
            ),
            SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  height: 50,
                  width: 280,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(child: Text('Selected Student : $student',style: TextStyle(color: Colors.white,fontSize: 16),))),
            ),

          ],
          SizedBox(height: 40,),
          SizedBox(
            height: 45,
            width: 220,
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // Adjust the radius as needed
                    side: BorderSide(color: Colors.black, width: 1.0), // Border color and width
                  ),
                ),
                onPressed: (){
              showDialog(
                context: context,
                builder: (BuildContext context) {
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
                                    "Add Student",

                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
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
                    content: SizedBox(
                      height: 250,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text('Enter the class',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500),),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                  decoration: InputDecoration(
                                    // isDense: true,

                                    contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 1.0),
                                    fillColor: Colors.white38,

                                    // labelText: "Search Here...",
                                    hintText: 'class',
                                    hintStyle: TextStyle(
                                        fontSize: 12 ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),


                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                  ],
                                  cursorColor: Colors.black,

                                  style: TextStyle(color: Colors.black,fontSize: 14 ),
                                  controller: controller1,


                                  validator: (value) => value!.isEmpty
                                      ? 'Please enter the class'
                                      : null,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (value){
                                    FocusScope.of(context).nextFocus();
                                  }



                              ),
                            ),
                            SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text('Enter the student name',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500),),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                maxLength: 10,
                                  cursorColor: Colors.black,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(50),
                                  ],

                                  style: TextStyle(color: Colors.black,fontSize: 14 ),
                                  controller: controller2,


                                  validator: (value) => value!.isEmpty
                                      ? 'Please enter the student name'
                                      : null,
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
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (value){
                                    FocusScope.of(context).nextFocus();
                                  }



                              ),
                            ),

                          ],
                        ),
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
                                      /*  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Hello, ${controller1.text}!')),
                                  );*/
                                      Student student = Student(name: controller2.text, className: controller1.text);
                                      int studentId = await helper.insert(student.toMap());

                                      // Query all rows
                                      List<Map<String, dynamic>> students = await helper.queryAllRows();

                                      Navigator.of(context).pop();
                                      SettingManager.mode =3;
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => MainMenu(),
                                        ),
                                      );
                                    }



                                  }, child: Text('ADD',style: TextStyle(color: Colors.white),)),
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
                                    setState(() {
                                      controller1.clear();
                                      controller2.clear();
                                    });





                                  }, child: Text('clear'.toUpperCase(),style: TextStyle(color: Colors.white),)),
                            ),
                          ),
                        ],
                      ),

                    ],
                  );
                },
              );
            }, label: Text('Add Student'),icon: Icon(Icons.add)),
          ),

          SizedBox(height: 10,),
          SizedBox(
            height: 45,
            width: 220,
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // Adjust the radius as needed
                    side: BorderSide(color: Colors.black, width: 1.0), // Border color and width
                  ),
                ),
                onPressed: (){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return allStudents();
                    },
                  );
                }, label: Text('View Students'),icon: Icon(Icons.view_day_sharp)),
          ),

        ],
      ),
    );
  }

  Future<Map<String,List<StudenNameID>>> getAllMapData() async{
    Map<String,List<StudenNameID>> classStudens = {};
    List<Map<String, dynamic>> test = [];
    test = await helper.queryAllRows();
    for (var item in test) {
      String classNum = item['class'];
      String name = item['name'];



      if(classStudens.containsKey(classNum)){
        classStudens[classNum]!.add(StudenNameID(id: item['id'],name: name));
      }else{
        classStudens[classNum] ??= [];
        classStudens[classNum]!.add(StudenNameID(id: item['id'],name: name));
      }



    }

    return classStudens;
  }
  Future<String> getAlldata() async{

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
    print(students.length);
    print(s1);

    List<String> allIds = [];
    s1.keys.forEach((idsList) {
      if(!classRomms.contains(idsList)){
        classRomms.add(idsList);
        classRomms.sort((a, b) => a.compareTo(b));
      }

    });
    setState(() {

    });



    print(allIds);
    return 'test';
  }

  String getRandomValue(String key) {
    List<StudenNameID> values = s1[key] ?? [];
    if (values.isEmpty) return 'No values for this key';

    Random random = Random();
    int randomIndex = random.nextInt(values.length);
    print(values[randomIndex]);
    return values[randomIndex].name;
  }
  Widget getStudens(mapList){
    TextEditingController name = TextEditingController();
    int? uid;
    String? uname;
    return StatefulBuilder(
        builder: (context, setState) {
        return Column(


          children: [
            TextFormField(
              controller: name,
            ),
            IconButton(onPressed: (

                ){
              helper.updateColumnName(uid!, name.text).then((value) {
                getAllMapData();
                setState(() {
                  print(value);
                });

              });

            }, icon: Icon(Icons.upload)),
            SizedBox(
              height: 300,
              width: 300,
              child: ListView.builder(
                itemCount: s1.length,
                itemBuilder: (context, index) {
                  String className = s1.keys.elementAt(index);
                  List<StudenNameID> students = s1[className] ?? [];

                  return Card(
                    margin: EdgeInsets.all(10.0),
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            'Class: $className',
                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10.0),
                          for (var student in students)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(student.name),
                                ),
                                Row(children: [
                                  IconButton(onPressed: (){
                                    setState(() {
                                      name.text = student.name;
                                      uid = student.id;

                                    });
                                  }, icon: Icon(Icons.edit)),
                                  IconButton(onPressed: (){

                                  }, icon: Icon(Icons.delete)),


                                ],)

                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }
    );
  }
}

