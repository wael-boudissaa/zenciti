import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zenciti/app/config/theme.dart';

class ButtonZencitiContainer extends StatefulWidget {
  final String textButton;
    final  void Function() onPressed;
  const ButtonZencitiContainer(
      {super.key, required this.textButton, required this.onPressed});

  @override
  State<ButtonZencitiContainer> createState() => _ButtonZencitiContainerState();
}

class _ButtonZencitiContainerState extends State<ButtonZencitiContainer> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: widget.onPressed, // This will trigger the onPressed callback
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.greenPrimary,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(20),
        width: 400,
        height: 70,
        child: Center(
          child: Text(
            widget.textButton,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
// Container(
//                     decoration: BoxDecoration(
//                       color: AppColors.greenPrimary,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     padding: EdgeInsets.all(20),
//                     width: 300,
//                     height: 80,
//                     child: Center(
//                       child: Text(
//                         "Create an account",
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.w700,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   )
