
import 'package:flutter/material.dart';
class ButtonRushCoif extends StatelessWidget
{
    final String textstring;
    final  void Function() onPressed;

    const ButtonRushCoif({Key? key,required String this.textstring,required this.onPressed}) : super(key: key);
    @override
    Widget build(BuildContext context) {
        return  ElevatedButton(
            onPressed:onPressed,
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(textstring,style: TextStyle(color: Colors.white,fontSize: 18.0,fontWeight:FontWeight.w500 ),),
            ),
        // 'RushCoiff',
        // style: TextStyle(
        //     fontSize: 50,
        //     fontWeight: FontWeight.bold,
        //     color: Colors.grey,
        // ),
        );
    }

}
