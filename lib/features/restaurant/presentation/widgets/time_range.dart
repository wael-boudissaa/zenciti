
import 'package:flutter/material.dart';
import 'package:time_range/time_range.dart';

class TimeRangePicker extends StatefulWidget {
  final Function(TimeRangeResult)? onRangeSelected;

  const TimeRangePicker({Key? key, this.onRangeSelected}) : super(key: key);

  @override
  _TimeRangePickerState createState() => _TimeRangePickerState();
}

class _TimeRangePickerState extends State<TimeRangePicker> {
  final Color gray = Colors.grey;
  final Color dark = Colors.black;
  final Color orange = Colors.orange;

  @override
  Widget build(BuildContext context) {
    return TimeRange(
      fromTitle: Text(
        'From',
        style: TextStyle(fontSize: 18, color: gray),
      ),
      toTitle: Text(
        'To',
        style: TextStyle(fontSize: 18, color: gray),
      ),
      titlePadding: 0,
      textStyle: TextStyle(fontWeight: FontWeight.normal, color: Colors.black87),
      activeTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      borderColor: dark,
      backgroundColor: Colors.transparent,
      activeBackgroundColor: orange,
      firstTime: TimeOfDay(hour: 14, minute: 30),
      lastTime: TimeOfDay(hour: 20, minute: 00),
      timeStep: 30,
      timeBlock: 30,
      onRangeCompleted: (range) {
        if (range != null) {
          setState(() {
            print(range);
            widget.onRangeSelected?.call(range);
          });
        }
      }, 
    );
  }
}
