import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenciti/features/home/presentation/widgets/appbar_pages.dart';
import 'package:zenciti/features/restaurant/domain/entities/tables.dart';
import 'dart:convert';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_event.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_table_bloc.dart';

class RestaurantLayoutScreen extends StatefulWidget {
  final String? idRestaurant;

  const RestaurantLayoutScreen({Key? key, this.idRestaurant}) : super(key: key);

  @override
  _RestaurantLayoutScreenState createState() => _RestaurantLayoutScreenState();
}

class _RestaurantLayoutScreenState extends State<RestaurantLayoutScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.idRestaurant != null) {
      context.read<RestaurantTableBloc>().add(
            RestaurantTableGetAll(idRestaurant: widget.idRestaurant!),
          );
    }
  }

  void _showTableDetails(RestaurantTable table) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Table ${table.idTable}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status: ${table.isAvailable ? 'Available' : 'Reserved'}'),
            if (!table.isAvailable) ...[
              Text('Reservation: ${table.reservationTime}'),
              Text('Duration: ${table.durationMinutes} minutes'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPages(),
      body: BlocBuilder<RestaurantTableBloc, RestaurantState>(
        builder: (context, state) {
          if (state is RestaurantLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is RestaurantFailure) {
            return Center(child: Text('Error: ${state.error}'));
          } else if (state is RestaurantSuccess) {
            final tables = state.restaurant;

            return Container(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  // Layout / Background here
                  ...tables.map((table) {
                    return Positioned(
                      left: table.posX.toDouble(),
                      top: table.posY.toDouble(),
                      child: GestureDetector(
                        onTap: () => _showTableDetails(table),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color:
                                table.isAvailable ? Colors.green : Colors.red,
                            border: Border.all(width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              table.idTable,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            );
          } else {
            return Center(child: Text('No data found.'));
          }
        },
      ),
    );
  }
}
