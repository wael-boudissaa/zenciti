import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zenciti/features/restaurant/domain/entities/menu.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_bloc.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_event.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_table_bloc.dart';

class FoodOrderPage extends StatefulWidget {
  final String idReservation;
  const FoodOrderPage({super.key, required this.idReservation});

  @override
  State<FoodOrderPage> createState() => _FoodOrderPageState();
}

class _FoodOrderPageState extends State<FoodOrderPage> {
  List<FoodItem> foodItems = [];

  void _submitOrderWithBloc(BuildContext context) {
    final selectedFoods = foodItems.where((item) => item.quantity > 0).toList();

    if (selectedFoods.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select at least one item.")));
      return;
    }

    context.read<RestaurantBloc>().add(OrderFood(
          idReservation: widget.idReservation,
          food: selectedFoods,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submit Food Order')),
      body: BlocConsumer<RestaurantBloc, RestaurantState>(
        listener: (context, state) {
          if (state is OrderSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            // Navigator.pop(context); // Optionally go back

            context.push('/reservation/qr', extra: widget.idReservation);
          } else if (state is RestaurantFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Failed: ${state.error}")),
            );
          }
        },
        builder: (context, state) {
          if (state is RestaurantLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MenuSuccess) {
            if (foodItems.isEmpty) {
              foodItems = state.menu
                  .map((item) => FoodItem(
                        idFood: item.idFood,
                        priceSingle: item.price,
                        quantity: 0,
                      ))
                  .toList();
            }

            return ListView.builder(
              itemCount: foodItems.length,
              itemBuilder: (context, index) {
                final item = foodItems[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(item.idFood),
                    subtitle: Text("\$${item.priceSingle.toStringAsFixed(2)}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            setState(() {
                              if (item.quantity > 0) item.quantity--;
                            });
                          },
                        ),
                        Text(item.quantity.toString()),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () {
                            setState(() {
                              item.quantity++;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is RestaurantFailure) {
            return Center(child: Text(state.error));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () => _submitOrderWithBloc(context),
          child: const Text("Submit Order"),
        ),
      ),
    );
  }
}
