import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_bloc.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_event.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_table_bloc.dart';

class ReservationPage extends StatefulWidget {
  final String idClient;
  final String idRestaurant;
  const ReservationPage({
    super.key,
    required this.idClient,
    required this.idRestaurant,
  });

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final _formKey = GlobalKey<FormState>();

  DateTime? _date;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  int _guests = 1;
  String? _tableId;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(Duration(days: 365)),
      selectableDayPredicate: (d) => d.weekday < DateTime.saturday,
    );
    if (date != null) setState(() => _date = date);
  }

  Future<void> _pickTime({required bool isStart}) async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (t != null) {
      setState(() {
        if (isStart)
          _startTime = t;
        else
          _endTime = t;
      });
    }
  }

  DateTime? _combine(TimeOfDay t) {
    if (_date == null) return null;
    return DateTime(
      _date!.year,
      _date!.month,
      _date!.day,
      t.hour,
      t.minute,
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final from = _combine(_startTime!);
    final to = _combine(_endTime!);

    context.go('/order', extra: widget.idRestaurant);
    if (from == null || to == null) {
      MotionToast.warning(
        description: Text("Please select date, start and end times."),
      ).show(context);
      return;
    }
    if (from.isAfter(to)) {
      MotionToast.error(
        description: Text("End time must be after start time."),
      ).show(context);
      return;
    }

    context.read<RestaurantBloc>().add(
          CreateReservation(
            idClient: widget.idClient,
            idRestaurant: widget.idRestaurant,
            idTable: _tableId!,
            timeFrom: from.toUtc(),
            timeTo: to.toUtc(),
            numberOfPeople: _guests,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Make a Reservation")),
      body: BlocListener<RestaurantBloc, RestaurantState>(
        listener: (ctx, state) {
          if (state is RestaurantLoading) {
            // could show a loading overlay if desired
          } else if (state is ReservationSuccess) {
            MotionToast.success(
              description: Text(state.message),
            ).show(ctx);
            context.go('/order',extra: 
                {
                    "idRestaurant": widget.idRestaurant,
                    "reservationId": state.reservationId,
                });
          } else if (state is RestaurantFailure) {
            print('Error: ${state.error}');
            MotionToast.error(
              description: Text(state.error),
            ).show(ctx);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Guests
                    DropdownButtonFormField<int>(
                      value: _guests,
                      decoration: InputDecoration(
                        labelText: 'Guests',
                        prefixIcon: Icon(Icons.people),
                        border: OutlineInputBorder(),
                      ),
                      items: [1, 2, 3, 4, 5, 6]
                          .map((n) => DropdownMenuItem(
                                value: n,
                                child: Text('$n'),
                              ))
                          .toList(),
                      onChanged: (v) => setState(() => _guests = v!),
                    ),
                    SizedBox(height: 16),

                    // Table ID
                    GestureDetector(
                      onTap: () async {
                        if (_date == null || _startTime == null) {
                          MotionToast.warning(
                            description: Text(
                                'Please select date and start time first.'),
                          ).show(context);
                          return;
                        }

                        final selectedTimeSlot =
                            _combine(_startTime!)!.toUtc().toIso8601String();

                        final selectedTable = await context.push<String>(
                          '/restaurant/tables',
                          extra: {
                            'idRestaurant': widget.idRestaurant,
                            'timeSlot': selectedTimeSlot,
                          },
                        );

                        if (selectedTable != null && mounted) {
                          setState(() {
                            _tableId = selectedTable
                                .toString(); // or selectedTable.idTable
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Table ID',
                            prefixIcon: Icon(Icons.table_bar),
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) =>
                              (_tableId == null || _tableId!.isEmpty)
                                  ? 'Required'
                                  : null,
                          controller:
                              TextEditingController(text: _tableId ?? ''),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Date picker
                    OutlinedButton.icon(
                      onPressed: _pickDate,
                      icon: Icon(Icons.calendar_today),
                      label: Text(_date == null
                          ? 'Select Date'
                          : _date!.toLocal().toString().split(' ')[0]),
                    ),
                    SizedBox(height: 16),

                    // Time pickers
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _pickTime(isStart: true),
                            icon: Icon(Icons.access_time),
                            label: Text(_startTime == null
                                ? 'Start Time'
                                : _startTime!.format(context)),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _pickTime(isStart: false),
                            icon: Icon(Icons.access_time_filled),
                            label: Text(_endTime == null
                                ? 'End Time'
                                : _endTime!.format(context)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),

                    // Create button
                    BlocBuilder<RestaurantBloc, RestaurantState>(
                      builder: (ctx, state) {
                        final loading = state is RestaurantLoading;
                        return ElevatedButton.icon(
                          onPressed: loading ? null : _submit,
                          icon: loading
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Icon(Icons.check),
                          label: Text(
                              loading ? 'Submitting...' : 'Create Reservation'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: Colors.orangeAccent,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

