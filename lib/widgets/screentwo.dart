import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp_text_field/style.dart';
import 'package:pinput/pinput.dart';


import '../Functions/methods.dart';
import 'package:otp_text_field/otp_text_field.dart';

class ScreenTwo extends StatefulWidget {
  const ScreenTwo({Key? key}) : super(key: key);

  @override
  State<ScreenTwo> createState() => _ScreenTwoState();
}


class _ScreenTwoState extends State<ScreenTwo> {
  TextEditingController controller1  = TextEditingController();
  // final PinputController _pinputController = PinputController();
  bool _editingField2 = false;
  int enabledButton = 2;



  @override
  void initState() {
    _focusNode = FocusNode();
    super.initState();
    // controller1.addListener(_handleTextChanged);
  }
  FocusNode? _focusNode;

  void _handleEnterKeyPressed() {
    // Handle Enter key press
    if(controller1.text.isNotEmpty){
      sendReading(controller1.text!);
      print(controller1.text!);

    }


    // sendReading('1234567890');

    print('Enter key pressed!');

  }
  void _handleEnterKeyPressedyy(String value) {
    // Handle Enter key press
    if(controller1.text.isNotEmpty)
      sendReading(controller1.text!);
    print(controller1.text!);
    // sendReading('1234567890');

    print('Enter key pressed!');

  }
  @override
  void dispose() {
    // TODO: implement dispose
    controller1.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_editingField2) {
      FocusScope.of(context).requestFocus(_focusNode);
    }
    final defaultPinTheme = PinTheme(

      width: 90.0,
      height:80,
      textStyle: const TextStyle(
        fontSize: 35,
        color: Colors.white,
        fontWeight: FontWeight.bold
      ),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 27, 27, 27),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black,),


      ),
    );
    return    RawKeyboardListener(
      focusNode: _focusNode!,
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.enter) {
            _handleEnterKeyPressed();
            if(controller1.text.isNotEmpty){
              // controller1.clear();
            }
          }
        }
      },
      child: SizedBox(
        width: 700,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Type Your message here',style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            )
            ),
            SizedBox(height: 30,),
            Pinput(
                onSubmitted: (pin) {
                  print('hi $pin');
                },
              onCompleted: (_){
                // print('object');
              },
              cursor: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(

                    margin: const EdgeInsets.only(bottom: 9),
                    width: 35,
                    height: 4,
                    color: Colors.white,
                  ),
                ],
              ),
              errorTextStyle: TextStyle(fontSize: 15,color: Colors.red),

              length: 10,

              controller: controller1,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9!@#\$%^&*()]')),
              ],

              // focusNode: focusNode,
              autofocus: true,
              androidSmsAutofillMethod:
              AndroidSmsAutofillMethod.smsUserConsentApi,
              // listenForMultipleSmsOnAndroid: true,
              defaultPinTheme: defaultPinTheme,
              mouseCursor: MouseCursor.defer,



              hapticFeedbackType: HapticFeedbackType.lightImpact,

              validator: (value){
                if(value!.isEmpty){
                  return "You must enter a !";
                }


                // return null;
              },

              followingPinTheme: defaultPinTheme,

              submittedPinTheme: defaultPinTheme,
              errorPinTheme: defaultPinTheme.copyBorderWith(
                border: Border.all(color: Colors.redAccent),
              ),
            ),
            SizedBox(height: 50,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black, // Set the border color
                      width: 2.0, // Set the border width
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor:enabledButton==1? Colors.black:Colors.white,
                    child: IconButton(
                      icon: Icon(
                        Icons.format_align_left,
                        color: enabledButton==1? Colors.white:Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          enabledButton=1;
                        });

                      },
                    ),
                  ),
                ),
              ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black, // Set the border color
                        width: 2.0, // Set the border width
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor:enabledButton==2? Colors.black:Colors.white,
                      child: IconButton(
                        icon: Icon(
                          Icons.format_align_center,
                          color: enabledButton==2? Colors.white:Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            enabledButton=2;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black, // Set the border color
                        width: 2.0, // Set the border width
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor:enabledButton==3? Colors.black:Colors.white,
                      child: IconButton(
                        icon: Icon(
                          Icons.format_align_right,
                          color: enabledButton==3? Colors.white:Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            enabledButton=3;
                          });
                        },
                      ),
                    ),
                  ),
                ),
            ],),
            SizedBox(height: 20,),
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
                  onPressed: (){
                    int printlength = 10;
                    int? whitespace;
                    if(enabledButton == 2){
                      whitespace = printlength - controller1.text!.length;
                      sendReading(addSpacesAroundWord(controller1.text!,whitespace!~/2));

                    }else if(enabledButton == 3){
                      whitespace = printlength - controller1.text!.length;
                      sendReading(addSpacesAroundWord(controller1.text!,whitespace));
                    }else{
                      sendReading(controller1.text!);
                    }

                         setState(() {
                           controller1.clear();
                         });



              }, child: Text('send',style: TextStyle(color: Colors.white),)),
            )

          ],
        ),
      ),
    );
  }

  String addSpacesAroundWord(String word, int spaces) {
    return ' ' * spaces + word;
  }
}
