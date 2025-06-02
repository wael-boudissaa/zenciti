import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:zenciti/features/restaurant/domain/entities/menu.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_bloc.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_event.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_table_bloc.dart';

class OrderPage extends StatefulWidget {
  final String idReservation;
  const OrderPage({Key? key, required this.idReservation}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class OrderItem {
  final MenuItem menuItem;
  int quantity;
  OrderItem({required this.menuItem, this.quantity = 1});
}

class _OrderPageState extends State<OrderPage> {
  final Map<String, OrderItem> _orderItems = {}; // key: idMenu

  void _changeQuantity(MenuItem menuItem, int delta) {
    setState(() {
      final id = menuItem.idFood;
      if (!_orderItems.containsKey(id)) {
        if (delta > 0) {
          // Always start from 1 on add, not delta, to prevent negative start
          _orderItems[id] = OrderItem(menuItem: menuItem, quantity: 1);
        }
      } else {
        _orderItems[id]!.quantity += delta;
        if (_orderItems[id]!.quantity <= 0) {
          _orderItems.remove(id);
        }
      }
    });
  }

  double get total => _orderItems.values
      .fold(0, (sum, item) => sum + item.menuItem.price * item.quantity);

  void _submitOrderWithBloc(BuildContext context, String idReservation) {
    final selectedFoods = _orderItems.values
        .where((item) => item.quantity > 0)
        .map((orderItem) => FoodItem(
              idFood: orderItem.menuItem.idFood,
              priceSingle: orderItem.menuItem.price,
              quantity: orderItem.quantity,
            ))
        .toList();

    if (selectedFoods.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select at least one item.")));
      return;
    }

    context.read<RestaurantBloc>().add(OrderFood(
          idReservation: idReservation,
          food: selectedFoods,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final primary = const Color(0xFF00614B);


    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: BlocConsumer<RestaurantBloc, RestaurantState>(
          listener: (context, state) {
            if (state is OrderSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              // Go to QR code page or wherever you want after order
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
            }
            if (state is MenuSuccess) {
              final menu = state.menu;
              if (menu.isEmpty) {
                return const Center(child: Text("No menu available."));
              }

              // Group menu items by category name
              final Map<String, List<MenuItem>> itemsByCategory = {};
              for (final item in menu) {
                final cat = item.menuName;
                if (!itemsByCategory.containsKey(cat)) {
                  itemsByCategory[cat] = [];
                }
                itemsByCategory[cat]!.add(item);
              }

              return Stack(
                children: [
                  ListView(
                    padding: const EdgeInsets.only(bottom: 150),
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Your Order",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                letterSpacing: 0.5,
                              ),
                            ),
                            IconButton(
                              icon: Icon(FontAwesomeIcons.ellipsisVertical,
                                  color: primary, size: 20),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      // Category sections
                      ...itemsByCategory.entries.expand((entry) => [
                            _sectionTitle(entry.key),
                            ...entry.value.map((item) => _menuItem(
                                  item: item,
                                  primary: primary,
                                  quantity:
                                      _orderItems[item.idFood]?.quantity ?? 0,
                                  onAdd: () => _changeQuantity(item, 1),
                                  onRemove: () => _changeQuantity(item, -1),
                                )),
                          ]),
                      // Order Items Section
                      _sectionTitle("Your Selected Items"),
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: _orderItems.isEmpty
                              ? [
                                  const Padding(
                                    padding: EdgeInsets.all(18.0),
                                    child: Text("No items selected."),
                                  )
                                ]
                              : _orderItems.values
                                  .map(
                                    (order) => _orderItemTile(
                                      item: order.menuItem,
                                      quantity: order.quantity,
                                      primary: primary,
                                      onMinus: () =>
                                          _changeQuantity(order.menuItem, -1),
                                      onPlus: () =>
                                          _changeQuantity(order.menuItem, 1),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                      const SizedBox(height: 90),
                    ],
                  ),
                  // Order Total & Checkout
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 72,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      color: Colors.white,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Subtotal",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                              Text(
                                "\$${total.toStringAsFixed(2)}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 17),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: _orderItems.isEmpty
                                  ? null
                                  : () {
                                      if (widget.idReservation != null) {
                                        _submitOrderWithBloc(
                                            context, widget.idReservation);
                                      }
                                    },
                              child: const Text(
                                "Proceed to Checkout",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // ... (Bottom navigation, as in your previous code)
                ],
              );
            }
            if (state is RestaurantFailure) {
              return Center(child: Text(state.error));
            }
            return const Center(child: Text("Loading menu..."));
          },
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  Widget _menuItem({
    required MenuItem item,
    required Color primary,
    required int quantity,
    required VoidCallback onAdd,
    required VoidCallback onRemove,
  }) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      margin: const EdgeInsets.only(bottom: 1),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Text("\$${item.price.toStringAsFixed(2)}",
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                    if (item.description != null &&
                        item.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(item.description!,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 13)),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: item.image != null && item.image!.isNotEmpty
                    ? Image.network(item.image!,
                        width: 72, height: 72, fit: BoxFit.cover)
                    : Container(
                        width: 72,
                        height: 72,
                        color: const Color(0xFFE5E5E5),
                        child: const Icon(Icons.image_not_supported),
                      ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  onPressed: onAdd,
                  child: const Text(
                    "Add",
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                ),
              ),
              if (quantity > 0)
                Row(
                  children: [
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: onRemove,
                      icon: const Icon(FontAwesomeIcons.minus,
                          size: 15, color: Colors.grey),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFFF3F4F6),
                        shape: const CircleBorder(),
                        minimumSize: const Size(34, 34),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        '$quantity',
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                    ),
                    IconButton(
                      onPressed: onAdd,
                      icon: const Icon(FontAwesomeIcons.plus,
                          size: 15, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: primary,
                        shape: const CircleBorder(),
                        minimumSize: const Size(34, 34),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _orderItemTile({
    required MenuItem item,
    required int quantity,
    required Color primary,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFF1F1F1), width: 1),
        ),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 15)),
                Text("\$${item.price.toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontSize: 13, color: Colors.grey, height: 1.2)),
              ],
            ),
          ]),
          Row(
            children: [
              IconButton(
                onPressed: onMinus,
                icon: const Icon(FontAwesomeIcons.minus,
                    size: 15, color: Colors.grey),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFF3F4F6),
                  shape: const CircleBorder(),
                  minimumSize: const Size(34, 34),
                  padding: EdgeInsets.zero,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '$quantity',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 15),
                ),
              ),
              IconButton(
                onPressed: onPlus,
                icon: const Icon(FontAwesomeIcons.plus,
                    size: 15, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: primary,
                  shape: const CircleBorder(),
                  minimumSize: const Size(34, 34),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// You must define FoodItem to match your Bloc OrderFood event.
// Here is a basic example (update as needed for your app):
