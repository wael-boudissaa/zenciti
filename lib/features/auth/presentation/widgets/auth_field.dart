import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {

  final String textlabel ;
  final TextEditingController controller;

  final ValueChanged<String>? onChanged;
  const AuthField({super.key,required this.textlabel,required TextEditingController this.controller, this.onChanged});


  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller, 
        onChanged: onChanged,
      decoration:InputDecoration(
          enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black)), 
          focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.greenAccent)),
        labelText: textlabel,
        
      ),
    );
  }
}
