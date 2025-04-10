import 'package:flutter/material.dart';
import 'package:zenciti/app/config/theme.dart';

class ButtonZencitiWhite extends StatefulWidget {
  final String textButton;
  final void Function() onPressed;
  const ButtonZencitiWhite(
      {super.key, required this.textButton, required this.onPressed});

  @override
  State<ButtonZencitiWhite> createState() => _ButtonZencitiWhiteState();
}

class _ButtonZencitiWhiteState extends State<ButtonZencitiWhite> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed, // This will trigger the onPressed callback
      borderRadius: BorderRadius.circular(
          20), // Ensure that the splash effect respects the rounded corners
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.greenPrimary, // Set the border color
            width: 1.0, // Set the border width
          ),
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
              color: AppColors.greenPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
