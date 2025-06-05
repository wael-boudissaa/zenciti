import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenciti/app/config/theme.dart';
import 'package:zenciti/features/auth/domain/entities/user.dart';
import 'package:zenciti/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:zenciti/features/auth/presentation/blocs/notification_bloc.dart';
import 'package:zenciti/features/auth/presentation/blocs/profile_information_bloc.dart';
import 'package:zenciti/features/auth/presentation/screens/profile_page.dart';

class ProfilePageUsername extends StatelessWidget {
  final String username;
  const ProfilePageUsername({super.key, required this.username});

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
                              ProfileStat(label: "Rated", value: "0"),
                              const SizedBox(width: 30),
                              ProfileStat(
                                  label: "Followers",
                                  value: user.followers.toString()),
                              const SizedBox(width: 30),
                              ProfileStat(
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
                                onPressed: () async {
                                  final storage = FlutterSecureStorage();
                                  final usernameSender =
                                      await storage.read(key: 'username');

                                  if (usernameSender != null) {
                                    context.read<NotificationBloc>().add(
                                          SendRequest(
                                              usernameSender, user.username),
                                        );
                                  } else {
                                    // Handle case when username is not found (optional)
                                    print(
                                        'Username not found in secure storage.');
                                  }
                                },
                                icon: const FaIcon(FontAwesomeIcons.userPlus,
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
                                  icon: const FaIcon(FontAwesomeIcons.userGroup,
                                      color: Colors.grey, size: 19),
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
                          ActivityCard(
                            name: user.firstName,
                            date: "12/10/2024",
                            place: "Magic pool",
                            popularity: 30,
                            imageUrl:
                                "https://storage.googleapis.com/uxpilot-auth.appspot.com/d2ebc99ea8-f972031e431f9fd3841c.png",
                          ),
                          ActivityCard(
                            name: user.firstName,
                            date: "12/10/2024",
                            place: "Magic pool",
                            popularity: 20,
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

// ... keep _ProfileStat, _ActivityCard, ActivityHeatmap, etc.
