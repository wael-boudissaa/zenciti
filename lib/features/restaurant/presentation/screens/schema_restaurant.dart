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

  const RestaurantLayoutScreen(
      {Key? key, this.idRestaurant, this.restaurantName})
      : super(key: key);

  @override
  _RestaurantLayoutScreenState createState() => _RestaurantLayoutScreenState();
}

class _RestaurantLayoutScreenState extends State<RestaurantLayoutScreen> {
  // Editor design canvas size (as in the web admin)
  static const double designWidth = 720;
  static const double designHeight = 520;
  static const double minPadding = 16;

  void _selectTableAndPop(RestaurantTable table) {
    Navigator.of(context).pop(table.idTable);
    // Or: context.pop(table.idTable);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Optionally reserve space for app bar/title/other widgets
    final double availableWidth = screenWidth - minPadding * 2;
    final double availableHeight =
        screenHeight - 190; // e.g. app bar + title + safe area

    // Calculate scale factor to fit the design canvas into the available area
    final double scaleX = availableWidth / designWidth;
    final double scaleY = availableHeight / designHeight;
    final double scale = scaleX < scaleY ? scaleX : scaleY;

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
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          width: designWidth * scale,
                          height: designHeight * scale,
                          color: Colors.grey[100],
                          child: Stack(
                            children: tables.map((table) {
                              // Use the original design positions and scale to fit the device
                              final double left = (table.posX ?? 0) * scale;
                              final double top = (table.posY ?? 0) * scale;
                              // Visual size for the table
                              final double size = 70 * scale;

                              // Color by status (reserved/other)
                              final color = (table.status == 'reserved')
                                  ? Colors.red
                                  : Colors.green;

                              // Use rounded or circular border based on table.shape if you want
                              BorderRadius borderRadius = BorderRadius.circular(
                                  (table.shape == 'circle')
                                      ? size / 2
                                      : 14 * scale);

                              return Positioned(
                                left: left,
                                top: top,
                                child: GestureDetector(
                                  onTap: () => _selectTableAndPop(table),
                                  child: Container(
                                    width: size,
                                    height: size,
                                    decoration: BoxDecoration(
                                      color: color,
                                      border: Border.all(
                                          width: 2 * scale,
                                          color: color.withOpacity(0.8)),
                                      borderRadius: borderRadius,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 6 * scale,
                                          offset: Offset(2 * scale, 4 * scale),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        table.idTable ?? '',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17 * scale),
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

