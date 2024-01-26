import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CusTomIconButton extends StatelessWidget {
  String? iconPath;
  final VoidCallback onPressed;
   CusTomIconButton({Key? key,required this.iconPath,required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      width: 75,
      child: IconButton(
        onPressed: onPressed,
        icon: Container(
          decoration: ShapeDecoration(
            color: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Center(
            child: SvgPicture.asset(iconPath!,
                color: Colors.white,
                width: 30, // Set the desired width
                height: 30),
          ),
        ),
      ),
    );
  }
}
