import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HotelLandingPage extends StatelessWidget {
  const HotelLandingPage({Key? key}) : super(key: key);

  Color get primary => const Color(0xFF00614B);
  Color get secondary => const Color(0xFFF5F5F5);
  Color get accent => const Color(0xFFFFD700);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar replacement
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
          child: Text(
            'Hello Indrit',
            style: TextStyle(color: primary, fontWeight: FontWeight.w500),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: primary,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 70), // for bottom nav
        child: ListView(
          children: [
            // Search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Stack(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      hintText: 'Search for activities',
                      hintStyle: const TextStyle(fontSize: 14),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(left: 12, right: 8),
                        child: Icon(FontAwesomeIcons.search, color: Colors.grey),
                      ),
                      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Icon(FontAwesomeIcons.locationDot, color: Colors.black87, size: 18),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Icon(FontAwesomeIcons.bell, color: Colors.black87, size: 18),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Categories
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
              child: Text(
                'All Activities',
                style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              ),
            ),
            SizedBox(
              height: 80,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildCategoryCircle(
                    imageUrl: 'https://storage.googleapis.com/uxpilot-auth.appspot.com/bd9d9c031d-526497692ae158a7b01c.png',
                    borderColor: primary,
                  ),
                  _buildCategoryCircle(
                    imageUrl: 'https://storage.googleapis.com/uxpilot-auth.appspot.com/76c3dc8509-25a2a60c8d9adcecbce5.png',
                    borderColor: primary,
                  ),
                  _buildCategoryCircle(
                    imageUrl: 'https://storage.googleapis.com/uxpilot-auth.appspot.com/640e766ad4-26daab9852c5e6ee7d4c.png',
                    borderColor: primary,
                  ),
                  _buildCategoryCircle(
                    imageUrl: 'https://storage.googleapis.com/uxpilot-auth.appspot.com/25e627647d-acce41020d2ea225d967.png',
                    borderColor: primary,
                  ),
                  _buildCategoryCircle(
                    imageUrl: null,
                    borderColor: Colors.grey[300],
                  ),
                  _buildCategoryCircle(
                    imageUrl: null,
                    borderColor: Colors.grey[300],
                  ),
                ],
              ),
            ),
            // Popular Restaurants
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
              child: Text(
                'Popular Restaurants',
                style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _RestaurantCard(
                imageUrl: 'https://storage.googleapis.com/uxpilot-auth.appspot.com/732295e6f2-c7169472da4c4c8ad1dc.png',
                title: 'Ocean View Restaurant',
                rating: 4.8,
                category: 'Fine Dining',
                accent: accent,
                primary: primary,
                buttonText: 'Book',
              ),
            ),
            // Popular Activities
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
              child: Text(
                'Popular Activities',
                style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _ActivityCard(
                    imageUrl: 'https://storage.googleapis.com/uxpilot-auth.appspot.com/d2ebc99ea8-f972031e431f9fd3841c.png',
                    title: 'Infinity Pool',
                    subTitle: 'Open 8AM - 8PM',
                    spotsLeft: '4 spots left',
                    buttonText: 'Reserve',
                    primary: primary,
                  ),
                  const SizedBox(height: 16),
                  _ActivityCard(
                    imageUrl: 'https://storage.googleapis.com/uxpilot-auth.appspot.com/630d98d7b9-9063b1e2cd2a2e0f2773.png',
                    title: 'Tennis Courts',
                    subTitle: 'Open 7AM - 10PM',
                    spotsLeft: '2 courts available',
                    buttonText: 'Book',
                    primary: primary,
                  ),
                ],
              ),
            ),
            // Meeting Spaces
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
              child: Text(
                'Meeting Spaces',
                style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _MeetingSpaceCard(
                imageUrl: 'https://storage.googleapis.com/uxpilot-auth.appspot.com/6b09b43463-a30b3202dcc69857cddd.png',
                title: 'Executive Conference Room',
                capacity: 'Capacity: 12',
                availability: 'Available Now',
                buttonText: 'Reserve',
                primary: primary,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 12,
        selectedItemColor: primary,
        unselectedItemColor: Colors.grey[400],
        backgroundColor: Colors.white,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.bolt),
            label: 'Activities',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.user),
            label: 'Profile',
          ),
        ],
        currentIndex: 0,
        onTap: (i) {},
      ),
    );
  }

  Widget _buildCategoryCircle({String? imageUrl, Color? borderColor}) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor ?? Colors.transparent, width: 2),
          shape: BoxShape.circle,
          color: Colors.grey[200],
        ),
        child: imageUrl != null
            ? ClipOval(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: 64,
                  height: 64,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported),
                ),
              )
            : null,
      ),
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double rating;
  final String category;
  final Color accent;
  final Color primary;
  final String buttonText;

  const _RestaurantCard({
    required this.imageUrl,
    required this.title,
    required this.rating,
    required this.category,
    required this.accent,
    required this.primary,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 2,
      child: Stack(
        children: [
          SizedBox(
            height: 180,
            width: double.infinity,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image_not_supported),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.black.withOpacity(0.55),
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16)),
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.solidStar, color: accent, size: 14),
                          const SizedBox(width: 4),
                          Text(rating.toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 13)),
                          const SizedBox(width: 8),
                          const Text('•',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 13)),
                          const SizedBox(width: 8),
                          Text(category,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 13)),
                        ],
                      )
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18))),
                    onPressed: () {},
                    child: Text(buttonText),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subTitle;
  final String spotsLeft;
  final String buttonText;
  final Color primary;

  const _ActivityCard({
    required this.imageUrl,
    required this.title,
    required this.subTitle,
    required this.spotsLeft,
    required this.buttonText,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          SizedBox(
            height: 180,
            width: double.infinity,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image_not_supported),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.black.withOpacity(0.55),
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Details
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16)),
                      Row(
                        children: [
                          const Icon(FontAwesomeIcons.clock, size: 13, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(subTitle,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 13)),
                          const SizedBox(width: 8),
                          const Text('•', style: TextStyle(color: Colors.white)),
                          const SizedBox(width: 8),
                          Text(spotsLeft,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18))),
                    onPressed: () {},
                    child: Text(buttonText),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _MeetingSpaceCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String capacity;
  final String availability;
  final String buttonText;
  final Color primary;

  const _MeetingSpaceCard({
    required this.imageUrl,
    required this.title,
    required this.capacity,
    required this.availability,
    required this.buttonText,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          SizedBox(
            height: 180,
            width: double.infinity,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image_not_supported),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.black.withOpacity(0.55),
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Details
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16)),
                      Row(
                        children: [
                          const Icon(FontAwesomeIcons.users, size: 13, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(capacity, style: const TextStyle(color: Colors.white, fontSize: 13)),
                          const SizedBox(width: 8),
                          const Text('•', style: TextStyle(color: Colors.white)),
                          const SizedBox(width: 8),
                          Text(availability, style: const TextStyle(color: Colors.white, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18))),
                    onPressed: () {},
                    child: Text(buttonText),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
