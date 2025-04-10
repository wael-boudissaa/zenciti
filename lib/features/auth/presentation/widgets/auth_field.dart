import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class AuthField extends StatelessWidget {
  final String textlabel;
  final TextEditingController controller;
  final IconButton? suffixIcon;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final String description;
  const AuthField(
      {
          super.key,
      required this.textlabel,
       required this.description,
      required TextEditingController this.controller,
      this.onChanged,
      this.obscureText = false,
      this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return FTextField(
      controller: controller,
      label:  Text(textlabel),
      // hint: 'Example',
      description:Text(description), 
      maxLines: 1,
    );
  }
}
