import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zenciti/features/restaurant/domain/entities/menu.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_bloc.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_table_bloc.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String selectedCategory = "All";

  static const categories = [
    "All",
    "Appetizers",
    "Seafood",
    "Steak",
    "Salads",
    "Desserts"
  ];

  @override
  Widget build(BuildContext context) {
    final Color primary = const Color(0xFF00614B);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<RestaurantBloc, RestaurantState>(
          builder: (context, state) {
            if (state is RestaurantLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is RestaurantFailure) {
              return Center(child: Text("Error: ${state.error}"));
            }
            if (state is MenuSuccess) {
              final menu = state.menu;
              final filteredMenu = selectedCategory == "All"
                  ? menu
                  : menu.where((item) => item.idCategory == selectedCategory).toList();
        
              return Stack(
                children: [
                  ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(context).maybePop(),
                              child: Text("Close",
                                  style: TextStyle(
                                      color: primary,
                                      fontWeight: FontWeight.w500)),
                            ),
                            const Text("Menu",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                            const SizedBox(width: 40), // balance
                          ],
                        ),
                      ),
                      // Title
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                        child: Text(
                          "Ocean View Restaurant",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[900]),
                        ),
                      ),
                      // Phone Button
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {},
                          icon: const FaIcon(FontAwesomeIcons.phone, size: 18),
                          label: const Text("(912)233-4453"),
                        ),
                      ),
                      // Menu Section Divider
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        child: Row(
                          children: const [
                            Text("Menu",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                          ],
                        ),
                      ),
                      // Menu Items
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            for (var i = 0; i < filteredMenu.length; i++) ...[
                              _MenuItemCard(
                                item: filteredMenu[i],
                                last: i == filteredMenu.length - 1,
                              )
                            ]
                          ],
                        ),
                      ),
                      // Categories
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 8),
                        child: Text("Categories",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 8,
                          children: [
                            for (final cat in categories)
                              ChoiceChip(
                                label: Text(cat),
                                selected: selectedCategory == cat,
                                onSelected: (sel) {
                                  setState(() {
                                    selectedCategory = cat;
                                  });
                                },
                                selectedColor: primary,
                                labelStyle: TextStyle(
                                  color: selectedCategory == cat
                                      ? Colors.white
                                      : Colors.grey[800],
                                  fontWeight: FontWeight.w500,
                                ),
                                backgroundColor: Colors.white,
                                side: BorderSide(color: Colors.grey[300]!),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 6),
                              ),
                          ],
                        ),
                      ),
                      // Reservation Button
                    ],
                  ),
                  // Bottom Navigation
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(top: BorderSide(color: Colors.grey.shade200)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _FooterNavItem(
                            icon: FontAwesomeIcons.home,
                            label: "Home",
                            selected: true,
                            color: primary,
                          ),
                          _FooterNavItem(
                            icon: FontAwesomeIcons.bolt,
                            label: "Activities",
                            selected: false,
                            color: Colors.grey[400]!,
                          ),
                          _FooterNavItem(
                            icon: FontAwesomeIcons.user,
                            label: "Profile",
                            selected: false,
                            color: Colors.grey[400]!,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final MenuItem item;
  final bool last;

  const _MenuItemCard({required this.item, required this.last, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: last ? EdgeInsets.zero : const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        border: last
            ? null
            : const Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 3),
                  Text(item.description,
                      style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 8),
                  Text("\$${item.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 15)),
                ],
              ),
            ),
          ),
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              item.image,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 90,
                height: 90,
                color: Colors.grey[200],
                child: Center(
                  child: Icon(
                    Icons.broken_image,
                    color: Colors.grey[400],
                    size: 40,
                  ),
                ),
              ),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 90,
                  height: 90,
                  color: Colors.grey[100],
                  child: const Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final Color color;

  const _FooterNavItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FaIcon(icon, color: color, size: 22),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        )
      ],
    );
  }
}
