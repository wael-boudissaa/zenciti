import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:zenciti/features/home/presentation/widgets/appbar_pages.dart';
import 'package:zenciti/features/restaurant/domain/entities/tables.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_bloc.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_event.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_table_bloc.dart';
import 'package:zenciti/features/restaurant/presentation/screens/restaurant_rating.dart';

class RestaurantDetailsPage extends StatefulWidget {
  const RestaurantDetailsPage({Key? key}) : super(key: key);

  @override
  State<RestaurantDetailsPage> createState() => _RestaurantDetailsPageState();
}

class _RestaurantDetailsPageState extends State<RestaurantDetailsPage>
    with SingleTickerProviderStateMixin {
  String? idClient;
  int tabIndex = 0;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadIdClient();
  }

  Future<void> _loadIdClient() async {
    final id = await storage.read(key: 'idClient');
    if (mounted) {
      setState(() {
        idClient = id;
      });
    }
  }

  void _showRatingDialog(
      BuildContext context, String idRestaurant, String idClient) async {
    showDialog(
      context: context,
      builder: (ctx) => RestaurantRatingDialog(
        onSubmit: (rating, comment) async {
          context.read<ReviewsBloc>().add(RatingRestaurant(
                idRestaurant: idRestaurant,
                idClient: idClient,
                rating: rating,
                comment: comment,
              ));
          // Optionally refresh friends reviews after rating
          context.read<ReviewsBloc>().add(GetFriendsReviews(
                idRestaurant: idRestaurant,
                idClient: idClient,
              ));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Thank you for your feedback!')),
          );
          context.pop(); // Close the dialog
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = const Color(0xFF00614B);
    final accent = const Color(0xFFFFD700);

    return Scaffold(
      appBar: AppBarPages(),
      backgroundColor: Colors.white,
      body: BlocBuilder<RestaurantBloc, RestaurantState>(
        builder: (context, restaurantState) {
          if (restaurantState is RestaurantLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (restaurantState is RestaurantFailure) {
            return Center(child: Text("Failed to load restaurant data"));
          }

          Restaurant? r;
          if (restaurantState is RestaurantSingleSuccess) {
            r = restaurantState.restaurant as Restaurant;
          } else if (restaurantState is RestaurantSuccess) {
            r = restaurantState.restaurant as Restaurant;
          } else if (restaurantState is RatingSucces) {
            // Optionally, you can handle rating success differently
          }

          if (r == null) {
            // Defensive: Shouldn't happen, but just in case.
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              ListView(
                padding: EdgeInsets.zero,
                children: [
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
                          style: const TextStyle(
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
                              style: const TextStyle(
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
                                      padding:
                                          const EdgeInsets.only(right: 2),
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () {
                              context.push('/reservation', extra: r);
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    child: GestureDetector(
                      onTap: () {
                        if (idClient != null) {
                          _showRatingDialog(
                              context, r!.idRestaurant, idClient!);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Please log in to rate this restaurant."),
                            ),
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F9F6),
                          borderRadius: BorderRadius.circular(13),
                          border:
                              Border.all(color: primary.withOpacity(0.10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 6,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 16),
                        child: Row(
                          children: [
                            Icon(FontAwesomeIcons.solidStar,
                                size: 28, color: Colors.amber[400]),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                "Share your experience! Tap to rate & review this restaurant.",
                                style: TextStyle(
                                  color: primary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios,
                                size: 18, color: Color(0xFF00614B)),
                          ],
                        ),
                      ),
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
                  if (tabIndex == 0)
                    BlocBuilder<ReviewsBloc, FriendsReviewState>(
                      builder: (context, reviewState) {
                        if (reviewState is FriendsReviewsLoading) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (reviewState is FriendsReviewsSuccess) {
                          final reviews = reviewState.reviews;
                          if (reviews == null || reviews.isEmpty) {
                            return _noFriendsReviewsUI(primary);
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${reviews.length} of your friends rated this restaurant",
                                  style: const TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                                const SizedBox(height: 18),
                                ...reviews.map((review) => _reviewCard(
                                      avatarUrl: _avatarForName(
                                          review.firstName, review.lastName),
                                      name:
                                          "${review.firstName} ${review.lastName}",
                                      rating: review.rating.toDouble(),
                                      review: review.comment,
                                      createdAt: review.createdAt,
                                      accent: accent,
                                      primary: primary,
                                    )),
                              ],
                            ),
                          );
                        }
                        if (reviewState is FriendsReviewsFailure) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Center(
                              child: Text(
                                "Couldn't load your friends' reviews.",
                                style: TextStyle(color: primary),
                              ),
                            ),
                          );
                        }
                        // Fallback for other states
                        return Container();
                      },
                    ),
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
                        context.push('/restaurant/menu',
                            extra: r!.idRestaurant);
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
              // Bottom nav unchanged
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
                          top:
                              BorderSide(color: Color(0xFFE5E7EB), width: 1)),
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
        },
      ),
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

  Widget _noFriendsReviewsUI(Color primary) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Center(
        child: Column(
          children: [
            Icon(FontAwesomeIcons.userFriends, color: primary, size: 48),
            const SizedBox(height: 18),
            Text(
              "None of your friends have rated this restaurant yet.",
              style: TextStyle(
                color: primary,
                fontWeight: FontWeight.w500,
                fontSize: 17,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "Be the first among your friends to leave a review!",
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _reviewCard({
    required String avatarUrl,
    required String name,
    required double rating,
    required String review,
    required DateTime createdAt,
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
                        color: primary,
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
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              review,
              style: const TextStyle(
                  color: Color(0xFF4B5563), fontSize: 14, height: 1.4),
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "${createdAt.day.toString().padLeft(2, '0')}/${createdAt.month.toString().padLeft(2, '0')}/${createdAt.year}",
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Generates a consistent avatar url for a friend based on their name
  String _avatarForName(String firstName, String lastName) {
    // For demo, you could use a static image or initials or a hash for random avatar
    // Here we use ui-avatars.com for initials
    return "https://ui-avatars.com/api/?name=$firstName+$lastName&background=E5E7EB&color=00614B&size=128";
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
