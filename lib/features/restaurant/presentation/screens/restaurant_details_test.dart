import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:zenciti/features/home/presentation/widgets/appbar.dart';
import 'package:zenciti/features/home/presentation/widgets/appbar_pages.dart';
import 'package:zenciti/features/restaurant/domain/entities/tables.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_bloc.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_table_bloc.dart';

class RestaurantDetailsPage extends StatefulWidget {
  const RestaurantDetailsPage({Key? key}) : super(key: key);

  @override
  State<RestaurantDetailsPage> createState() => _RestaurantDetailsPageState();
}

class _RestaurantDetailsPageState extends State<RestaurantDetailsPage>
    with SingleTickerProviderStateMixin {
  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final primary = const Color(0xFF00614B);
    final accent = const Color(0xFFFFD700);

    return Scaffold(
      appBar: AppBarPages(),
      backgroundColor: Colors.white,
      body: BlocBuilder<RestaurantBloc, RestaurantState>(
          builder: (context, state) {
        if (state is RestaurantLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is RestaurantSingleSuccess) {
          final r = state.restaurant as Restaurant;
          return Stack(
            children: [
              ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Header

                  // Restaurant Image
                  SizedBox(
                    height: 240,
                    width: double.infinity,
                    child: Image.network(
                      "${r.image}",
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) =>
                          Container(color: Colors.grey[200]),
                    ),
                  ),

                  // Details
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${r.nameR}",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 24),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(FontAwesomeIcons.locationDot,
                                color: primary, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              "${r.location}",
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 15),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Row(
                                  children: List.generate(
                                    5,
                                    (i) => Padding(
                                      padding: const EdgeInsets.only(right: 2),
                                      child: Icon(
                                        FontAwesomeIcons.solidStar,
                                        color: Colors.amber[400],
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  "1500+ reviews",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                            const SizedBox(),
                          ],
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () {
                              context.push('/reservation',
                                  extra: r);
                            },
                            child: const Text(
                              "Make Reservation",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tab Navigation
                  Material(
                    color: Colors.white,
                    child: Container(
                      height: 52,
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Color(0xFFE5E7EB), width: 1))),
                      child: Row(
                        children: [
                          _tabButton("Reviews", 0, primary),
                          _tabButton("Details", 1, primary),
                          _tabButton("Menu", 2, primary),
                        ],
                      ),
                    ),
                  ),

                  // Content
                  if (tabIndex == 0) _buildReviewsSection(primary, accent)
                  // Add Details or Menu tabs here if needed
                  ,

                  // Menu Button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 90),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                      context.push('/restaurant/menu', extra: r.idRestaurant);

                      },
                      icon: const Icon(FontAwesomeIcons.utensils, size: 18),
                      label: const Text(
                        "Check MENU",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),

              // Bottom nav
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Material(
                  elevation: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          top: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _bottomNavItem(
                            "Home", FontAwesomeIcons.home, true, primary),
                        _bottomNavItem("Activities", FontAwesomeIcons.bolt,
                            false, primary),
                        _bottomNavItem(
                            "Profile", FontAwesomeIcons.user, false, primary),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        } else if (state is RestaurantFailure) {
          return Center(child: Text("Failed to load restaurant data"));
        } else {
          // Default fallback to avoid returning null
          return const Center(child: Text("Something went wrong"));
        }
      }),
    );
  }

  Widget _tabButton(String label, int idx, Color primary) => Expanded(
        child: GestureDetector(
          onTap: () {
            setState(() {
              tabIndex = idx;
            });
          },
          child: Container(
            alignment: Alignment.center,
            decoration: tabIndex == idx
                ? BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: primary, width: 2)),
                  )
                : null,
            child: Text(
              label,
              style: TextStyle(
                color: tabIndex == idx ? primary : Colors.grey[500],
                fontWeight:
                    tabIndex == idx ? FontWeight.w500 : FontWeight.normal,
                fontSize: 16,
              ),
            ),
          ),
        ),
      );

  Widget _buildReviewsSection(Color primary, Color accent) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "2 of your friends rated this restaurant",
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 16),
          ),
          const SizedBox(height: 18),
          // Review 1
          _reviewCard(
            avatarUrl:
                "https://storage.googleapis.com/uxpilot-auth.appspot.com/avatars/avatar-1.jpg",
            name: "Indrit Alushani",
            rating: 5,
            review: "Take the chicken and thank me later",
            accent: accent,
            primary: primary,
          ),
          // Review 2
          _reviewCard(
            avatarUrl:
                "https://storage.googleapis.com/uxpilot-auth.appspot.com/avatars/avatar-3.jpg",
            name: "Alex Marino",
            rating: 4.5,
            review:
                "Great seafood and amazing sunset views. The service was exceptional!",
            accent: accent,
            primary: primary,
          ),
          // Review 3
          _reviewCard(
            avatarUrl:
                "https://storage.googleapis.com/uxpilot-auth.appspot.com/avatars/avatar-5.jpg",
            name: "Sarah Johnson",
            rating: 5,
            review:
                "Perfect for special occasions. The wine selection is impressive!",
            accent: accent,
            primary: primary,
          ),
        ],
      ),
    );
  }

  Widget _reviewCard({
    required String avatarUrl,
    required String name,
    required double rating,
    required String review,
    required Color accent,
    required Color primary,
  }) {
    final int fullStars = rating.floor();
    final bool halfStar = (rating - fullStars) >= 0.5;
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar & Name
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(avatarUrl),
                    radius: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    name,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: name == "Indrit Alushani"
                            ? primary
                            : Colors.black87,
                        fontSize: 15),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  ...List.generate(
                    fullStars,
                    (_) => Icon(FontAwesomeIcons.solidStar,
                        color: Colors.amber[400], size: 16),
                  ),
                  if (halfStar)
                    Icon(FontAwesomeIcons.starHalfAlt,
                        color: Colors.amber[400], size: 16),
                ],
              )
            ],
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              review,
              style: const TextStyle(
                  color: Color(0xFF4B5563), fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomNavItem(
      String label, IconData icon, bool selected, Color primary) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: selected ? primary : Colors.grey[400], size: 22),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
              color: selected ? primary : Colors.grey[400],
              fontSize: 12,
              fontWeight: selected ? FontWeight.w500 : FontWeight.normal),
        )
      ],
    );
  }
}
