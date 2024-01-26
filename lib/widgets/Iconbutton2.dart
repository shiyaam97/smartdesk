import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class IconButton2 extends StatelessWidget {
  String? iconPath;
  final VoidCallback onPressed;
  IconButton2({Key? key, required this.onPressed,required this.iconPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      width: 75,
      child: IconButton(
          onPressed: onPressed,
          icon: Center(
            child: SvgPicture.asset(iconPath!,
                color: Colors.black,
                width: 30, // Set the desired width
                height: 30),
          )),
    );
  }
}
