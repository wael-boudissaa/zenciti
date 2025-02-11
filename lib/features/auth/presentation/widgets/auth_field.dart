
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {

  final String textlabel ;
  final TextEditingController controller;
final IconButton? suffixIcon;
  final bool obscureText ;
  final ValueChanged<String>? onChanged;
  const AuthField({super.key,required this.textlabel,required TextEditingController this.controller, this.onChanged,this.obscureText = false ,  this.suffixIcon});


  @override
  Widget build(BuildContext context) {
    return TextField(
        style: TextStyle(color: Colors.black87,fontSize: 15,fontWeight: FontWeight.normal),
        controller: controller, 
        onChanged: onChanged,
        obscureText: obscureText,
      decoration:InputDecoration(
          enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black)), 
          focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.greenAccent)
              ),

          labelStyle: TextStyle(color: Colors.grey,fontSize: 15,fontWeight: FontWeight.w400),
        labelText: textlabel,
        suffixIcon: suffixIcon,
        
      ),
    );
  }
}
