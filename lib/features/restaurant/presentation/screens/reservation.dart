import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:zenciti/features/home/presentation/widgets/appbar_pages.dart';
import 'package:zenciti/features/restaurant/presentation/widgets/time_range.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  DateTime? selectedDateTime;
  int selectedGuests = 1;

  void _pickDateOnly() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(Duration(days: 365 * 5)),
      selectableDayPredicate: (date) =>
          date.weekday != DateTime.saturday && date.weekday != DateTime.sunday,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.white,
            colorScheme: ColorScheme.light(
              primary: Colors.orange,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        selectedDateTime = date;
      });
    }
  }

  void _showTableStatusPopup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Table Availability'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('For $selectedGuests guests'),
            SizedBox(height: 10),
            Text(
              'Tables available: ${selectedGuests == 1 ? 3 : selectedGuests == 2 ? 2 : 1}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('This is just a demo – connect real data here later.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPages(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<int>(
              value: selectedGuests,
              decoration: InputDecoration(
                labelText: 'Number of guests',
                border: OutlineInputBorder(),
              ),
              items: List.generate(4, (index) {
                int value = index + 1;
                return DropdownMenuItem(
                  value: value,
                  child: Text('$value ${value == 1 ? 'person' : 'people'}'),
                );
              }),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedGuests = value;
                  });
                }
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickDateOnly,
              child: Text("Select Reservation Date"),
            ),
            if (selectedDateTime != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Selected date: ${selectedDateTime!.toLocal().toString().split(' ')[0]}",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            SizedBox(height: 20),
            TimeRangePicker(
              onRangeSelected: (range) {
                print("User selected: ${range.start} to ${range.end}");
              },
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _showTableStatusPopup,
              icon: Icon(Icons.table_bar),
              label: Text("Check Table Availability"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

