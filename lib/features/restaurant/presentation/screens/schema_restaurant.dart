import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zenciti/features/home/presentation/widgets/appbar_pages.dart';
import 'package:zenciti/features/restaurant/domain/entities/tables.dart';
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
    // if (widget.idRestaurant != null) {
    //   context.read<RestaurantTableBloc>().add(
    //         RestaurantTableGetAll(idRestaurant: widget.idRestaurant!,
    //             timeSlot: widget.
    //       );
    // }
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
            Text('Status: ${table.status ?? 'unknown'}'),
            if (table.status == 'reserved' &&
                table.timeFrom != null &&
                table.timeTo != null) ...[
              SizedBox(height: 8),
              Text('From: ${table.timeFrom}'),
              Text('To: ${table.timeTo}'),
              if (table.numberOfPeople != null)
                Text('Number of People: ${table.numberOfPeople}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => {
              Navigator.pop(context, table.idTable),
              context.pop(table.idTable),
            },
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
            final tables = state.restaurant as List<RestaurantTable>;

            return Stack(
              children: tables.map((table) {
                final color =
                    (table.status == 'reserved') ? Colors.red : Colors.green;
                final double left = table.posX?.toDouble() ?? 0.0;
                final double top = table.posY?.toDouble() ?? 0.0;

                return Positioned(
                  left: left,
                  top: top,
                  child: GestureDetector(
                    onTap: () => _showTableDetails(table),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: color,
                        border: Border.all(width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          table.idTable ?? '',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          } else {
            return Center(child: Text('No data found.'));
          }
        },
      ),
    );
  }
}
