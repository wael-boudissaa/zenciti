import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zenciti/features/home/presentation/widgets/appbar_pages.dart';
import 'package:zenciti/features/restaurant/domain/entities/tables.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_event.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_table_bloc.dart';

class RestaurantLayoutScreen extends StatefulWidget {
  final String? idRestaurant;
  final String? restaurantName;

  const RestaurantLayoutScreen({Key? key, this.idRestaurant, this.restaurantName}) : super(key: key);

  @override
  _RestaurantLayoutScreenState createState() => _RestaurantLayoutScreenState();
}

class _RestaurantLayoutScreenState extends State<RestaurantLayoutScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch tables if needed
    // if (widget.idRestaurant != null) {
    //   context.read<RestaurantTableBloc>().add(RestaurantTableGetAll(
    //       idRestaurant: widget.idRestaurant!,
    //       timeSlot: ... // pass your timeslot
    //   ));
    // }
  }

  void _selectTableAndPop(RestaurantTable table) {
    // Only return the id of the table
    Navigator.of(context).pop(table.idTable);
    // context.pop(table.idTable); // If using go_router context.pop
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
            if (tables.isEmpty) {
              return Center(child: Text('No tables found.'));
            }

            // Calculate layout size dynamically based on max posX/posY
            final maxX = tables.map((t) => t.posX ?? 0).fold<int>(0, (v, e) => e > v ? e : v);
            final maxY = tables.map((t) => t.posY ?? 0).fold<int>(0, (v, e) => e > v ? e : v);

            // Add more padding for more space
            final double minWidth = 450;
            final double minHeight = 450;
            final layoutWidth = (maxX + 100).toDouble() < minWidth ? minWidth : (maxX + 100).toDouble();
            final layoutHeight = (maxY + 100).toDouble() < minHeight ? minHeight : (maxY + 100).toDouble();

            return Column(
              children: [
                if (widget.restaurantName != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 10),
                    child: Text(
                      widget.restaurantName!,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ),
                Expanded(
                  child: Center(
                    child: InteractiveViewer(
                      minScale: 0.7,
                      maxScale: 2.5,
                      boundaryMargin: EdgeInsets.all(50),
                      child: Container(
                        color: Colors.grey[100],
                        width: layoutWidth,
                        height: layoutHeight,
                        child: Stack(
                          children: tables.map((table) {
                            final color = (table.status == 'reserved')
                                ? Colors.red
                                : Colors.green;
                            final double left = (table.posX ?? 0).toDouble();
                            final double top = (table.posY ?? 0).toDouble();

                            return Positioned(
                              left: left,
                              top: top,
                              child: GestureDetector(
                                onTap: () => _selectTableAndPop(table),
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: color,
                                    border: Border.all(width: 2, color: color.withOpacity(0.8)),
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 6,
                                        offset: Offset(2, 4),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      table.idTable ?? '',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
              ],
            );
          } else {
            return Center(child: Text('No data found.'));
          }
        },
      ),
    );
  }
}
