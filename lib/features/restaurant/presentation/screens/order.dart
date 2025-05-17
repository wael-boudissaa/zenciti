import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:zenciti/features/restaurant/domain/entities/menu.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_bloc.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_table_bloc.dart';

class FoodOrderPage extends StatefulWidget {
  const FoodOrderPage({super.key});

  @override
  State<FoodOrderPage> createState() => _FoodOrderPageState();
}

class _FoodOrderPageState extends State<FoodOrderPage> {
  final String reservationId =
      "7267f102-12fa-4c28-adda-95e7172cd8ca"; // Replace dynamically if needed
  List<FoodItem> foodItems = [];

  Future<void> submitOrder() async {
    final selectedFoods = foodItems
        .where((item) => item.quantity > 0)
        .map((item) => {
              "idFood": item.idFood,
              "quantity": item.quantity,
              "priceSingle": item.priceSingle,
            })
        .toList();

    final body = {
      "idReservation": reservationId,
      "foods": selectedFoods,
    };
    print("Body: $body");

    final response = await http.post(
      Uri.parse("http://localhost:8080/order/place"), // Update with your IP
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Order submitted!")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed: ${response.body}")));
      print("Failed to submit order: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submit Food Order')),
      body: BlocBuilder<RestaurantBloc, RestaurantState>(
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
                    title: Text(foodItems[index].idFood),
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
          onPressed: submitOrder,
          child: const Text("Submit Order"),
        ),
      ),
    );
  }
}

