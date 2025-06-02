import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenciti/app/config/theme.dart';
import 'package:zenciti/features/auth/domain/entities/user.dart';
import 'package:zenciti/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:zenciti/features/auth/presentation/blocs/profile_information_bloc.dart'; // For SignUpState, ProfileInformationSuccess, etc.

class ProfilePage extends StatelessWidget {
  final String idClient;
  const ProfilePage({super.key, required this.idClient});

  @override
  Widget build(BuildContext context) {
    const accent = AppColors.primary;
    const primary = AppColors.primary;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          BlocBuilder<ProfileInformationBloc, SignUpState>(
            builder: (context, state) {
              if (state is SignUpLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is SignUpFailure) {
                return Center(child: Text(state.error));
              }
              if (state is ProfileInformationSuccess) {
                final UserProfile user = state.user;
                return ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
                      child: Row(
                        children: [
                          const Expanded(child: SizedBox()),
                          const Expanded(
                            child: Center(
                              child: Text(
                                "Profile",
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: const FaIcon(FontAwesomeIcons.gear,
                                    size: 23, color: Colors.grey),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Profile Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 6),
                          Container(
                            width: 96,
                            height: 96,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE5E7EB),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                user.firstName.isNotEmpty
                                    ? user.firstName[0].toUpperCase()
                                    : "",
                                style: TextStyle(
                                  color: primary,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            "${user.firstName} ${user.lastName}",
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            user.username,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 15),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user.address,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 14),
                          ),
                          const SizedBox(height: 12),
                          // Stats
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _ProfileStat(label: "Rated", value: "0"),
                              const SizedBox(width: 30),
                              _ProfileStat(
                                  label: "Followers",
                                  value: user.followers.toString()),
                              const SizedBox(width: 30),
                              _ProfileStat(
                                  label: "Following",
                                  value: user.following.toString()),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Actions
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accent,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 11),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                  textStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                onPressed: () {},
                                icon: const FaIcon(
                                    FontAwesomeIcons.userPlus,
                                    size: 16),
                                label: const Text("Follow"),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: IconButton(
                                  icon: const FaIcon(
                                      FontAwesomeIcons.userGroup,
                                      color: Colors.grey,
                                      size: 19),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    // Last Activities Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Last activities",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 14),
                          // You can fetch activities dynamically here if needed
                          _ActivityCard(
                            name: user.firstName,
                            date: "12/10/2024",
                            place: "Magic pool",
                            people: 2,
                            rating: 4.5,
                            imageUrl:
                                "https://storage.googleapis.com/uxpilot-auth.appspot.com/d2ebc99ea8-f972031e431f9fd3841c.png",
                          ),
                          _ActivityCard(
                            name: user.firstName,
                            date: "12/10/2024",
                            place: "Magic pool",
                            people: 2,
                            rating: 4.5,
                            imageUrl:
                                "https://storage.googleapis.com/uxpilot-auth.appspot.com/d2ebc99ea8-f972031e431f9fd3841c.png",
                          ),
                          const SizedBox(height: 6),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 15),
                              minimumSize: const Size.fromHeight(0),
                            ),
                            child: const Text("View more"),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Activity Heatmap Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 2),
                          const Text(
                            "35 activities last month",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 17),
                          ),
                          const SizedBox(height: 16),
                          ActivityHeatmap(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 110),
                  ],
                );
              }
              // Default/empty state
              return const Center(child: Text("No profile data"));
            },
          ),
          // Bottom Navigation can be added here if needed
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileStat({required this.label, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
      ],
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final String name;
  final String date;
  final String place;
  final int people;
  final double rating;
  final String imageUrl;

  const _ActivityCard({
    required this.name,
    required this.date,
    required this.place,
    required this.people,
    required this.rating,
    required this.imageUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 5,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(13),
              bottomLeft: Radius.circular(13),
            ),
            child: Image.network(
              imageUrl,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 90,
                height: 90,
                color: Colors.grey[200],
                child: const Icon(Icons.broken_image,
                    size: 34, color: Colors.grey),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              child: Text(
                "$name on $date took a reservation to the $place for $people people and he rated the place $rating",
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ActivityHeatmap extends StatelessWidget {
  ActivityHeatmap({super.key});

  // The color designations, matching the HTML
  static const accent = Color(0xFF00A67E);
  static const green200 = Color(0xFFA7F3D0);
  static const green100 = Color(0xFFD1FAE5);
  static const green500 = Color(0xFF10B981);
  static const green800 = Color(0xFF166534);
  static const white = Colors.white;

  // The heatmap data as rows of 7
  final List<List<Color>> heatmap = const [
    // Row 1
    [green200, green100, green200, accent, green800, white, white],
    // Row 2
    [green200, green200, green200, white, accent, green200, green200],
    // Row 3
    [green500, green500, white, white, white, green200, accent],
    // Row 4
    [green500, green500, white, green200, green500, green500, green500],
    // Row 5
    [green500, green500, green200, white, green500, green500, white],
    // Row 6
    [green500, green100, green200, green500, green500, green200, white],
    // Row 7
    [green500, green200, green100, green500, green200, white, white],
    // Row 8
    [green100, green200, green200, accent, green200, accent, white],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final row in heatmap)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (final color in row)
                  Container(
                    width: 32,
                    height: 32,
                    margin: const EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _FooterNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final Color color;
  final bool dot;

  const _FooterNavItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.color,
    this.dot = false,
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
        ),
        if (dot)
          Container(
            margin: const EdgeInsets.only(top: 2),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }
}
