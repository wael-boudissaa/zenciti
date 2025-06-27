import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenciti/features/auth/domain/entities/notification.dart';
import 'package:zenciti/features/auth/presentation/blocs/notification_bloc.dart';
import 'package:zenciti/features/auth/presentation/blocs/notification_state.dart';
// Import your NotificationBloc, NotificationState, NotificationEvent, FriendRequestList here

class NotificationPage extends StatefulWidget {
  final String idClient;
  const NotificationPage({super.key, required this.idClient});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int selectedTab = 0; // 0: All, 1: Alerts, 2: Friend Requests

  // For demonstration, these notifications are static. You may get them from your backend.
  final List<_NotificationItem> notifications = [
    _NotificationItem(
      icon: FontAwesomeIcons.triangleExclamation,
      color: Colors.red,
      bgColor: Color(0xFFFFE5E5),
      title: "Severe Weather Alert",
      description:
          '"Heavy rainfall expected in your area tonight with potential flooding in low-lying areas. Please avoid unnecessary travel, and stay safe. Keep updated through local authorities for further instructions."',
    ),
    _NotificationItem(
      icon: FontAwesomeIcons.info,
      color: Colors.blue,
      bgColor: Color(0xFFDBF3FE),
      title: "Street Maintenance Update",
      description:
          "Road repairs are scheduled on Main Street from Monday to Friday this week, 8:00 AM to 6:00 PM. Expect possible delays and detours. Thank you for your patience as we work to improve our city roads!",
    ),
    _NotificationItem(
      icon: FontAwesomeIcons.calendar,
      color: Colors.green,
      bgColor: Color(0xFFE0F9ED),
      title: "Upcoming Farmers Market Event!",
      description:
          "Join us this Saturday from 8:00 AM to 2:00 PM at City Square for the local Farmers Market. Enjoy fresh produce, artisan goods, and family-friendly activities. We look forward to seeing you there!",
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Dispatch load notification event
    context.read<NotificationBloc>().add(NotificationGet(widget.idClient));
  }

  @override
  Widget build(BuildContext context) {
    const Color primary = Color(0xFF00614B);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              child: Row(
                children: [
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.arrowLeft,
                        color: Colors.grey),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      height: 40,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search for activities",
                          fillColor: Colors.grey[100],
                          filled: true,
                          prefixIcon: Icon(Icons.search,
                              color: Colors.grey[400], size: 20),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22),
                            borderSide: BorderSide.none,
                          ),
                          isDense: true,
                        ),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: const FaIcon(FontAwesomeIcons.envelope,
                            color: Colors.grey, size: 20),
                        onPressed: () {},
                      ),
                      Positioned(
                        right: 6,
                        top: 8,
                        child: _NotificationBadge(count: 3),
                      )
                    ],
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: const FaIcon(FontAwesomeIcons.bell,
                            color: Colors.grey, size: 20),
                        onPressed: () {},
                      ),
                      Positioned(
                        right: 6,
                        top: 8,
                        child: _NotificationBadge(count: 5),
                      )
                    ],
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    margin: const EdgeInsets.only(left: 6),
                    decoration: BoxDecoration(
                      color: primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
            // Page Title
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: const Text(
                "Notification Page",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            // Tabs
            Container(
              padding: const EdgeInsets.only(left: 16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
              ),
              child: Row(
                children: [
                  _TabButton(
                    label: "All",
                    selected: selectedTab == 0,
                    onTap: () => setState(() => selectedTab = 0),
                    color: primary,
                  ),
                  _TabButton(
                    label: "Alerts",
                    selected: selectedTab == 1,
                    onTap: () => setState(() => selectedTab = 1),
                    color: primary,
                  ),
                  _TabButton(
                    label: "Friend Requests",
                    selected: selectedTab == 2,
                    onTap: () => setState(() => selectedTab = 2),
                    color: primary,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  if (selectedTab == 0 || selectedTab == 2) ...[
                    // Friend Requests
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
                      child: Text(
                        "Friend Requests",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: Colors.grey[900],
                        ),
                      ),
                    ),
                    BlocBuilder<NotificationBloc, NotificationState>(
                      builder: (context, state) {
                        if (state is NotificationLoading) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (state is NotificationFailure) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Center(child: Text(state.error)),
                          );
                        }
                        if (state is NotificationSucces) {
                          final list = state.friendRequestList;
                          if (list.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Center(child: Text("No friend requests.")),
                            );
                          }
                          return Column(
                            children: [
                              for (final req in list)
                                _FriendRequestCard(request: req),
                            ],
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ],
                  if (selectedTab == 0 || selectedTab == 1) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                      child: Text(
                        "Notifications",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: Colors.grey[900],
                        ),
                      ),
                    ),
                    for (final n in notifications)
                      _NotificationListCard(item: n),
                  ],
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color color;

  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.only(right: 16, left: 0, bottom: 4),
        minimumSize: const Size(0, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: selected ? color : Colors.grey[500],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 3),
            height: 2,
            width: 30,
            color: selected ? color : Colors.transparent,
          ),
        ],
      ),
    );
  }
}

class _NotificationBadge extends StatelessWidget {
  final int count;
  const _NotificationBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        "$count",
        style: const TextStyle(
            color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _FriendRequestCard extends StatelessWidget {
  final FriendRequestList request;

  const _FriendRequestCard({required this.request});

  @override
  Widget build(BuildContext context) {
    // Dummy data for demo avatars and names
    final Map<String, String> userAvatars = {
      "alex":
          "https://storage.googleapis.com/uxpilot-auth.appspot.com/avatars/avatar-2.jpg",
      "sarah":
          "https://storage.googleapis.com/uxpilot-auth.appspot.com/avatars/avatar-5.jpg",
      "michael":
          "https://storage.googleapis.com/uxpilot-auth.appspot.com/avatars/avatar-3.jpg",
    };

    // For demonstration, just use sender as name, you can enhance with real user fetch
    String senderName = request.username;
    String avatarUrl =
        userAvatars.entries.elementAt(3.hashCode % userAvatars.length).value;
    String mutual = "3";

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          ClipOval(
            child: Image.network(
              avatarUrl,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (c, e, st) => Container(
                width: 48,
                height: 48,
                color: Colors.grey[300],
                child: const Icon(Icons.person, size: 28, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(senderName,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16)),
                Text(mutual,
                    style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
          Row(
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF00614B),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                ),
                onPressed: () {
                  context
                      .read<NotificationBloc>()
                      .add(AcceptRequest(request.idFriendship));

                  // Accept friend request logic
                },
                child: const Text("Accept", style: TextStyle(fontSize: 13)),
              ),
              const SizedBox(width: 7),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.grey[700],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                ),
                onPressed: () {
                  // Decline friend request logic
                },
                child: const Text("Decline", style: TextStyle(fontSize: 13)),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _NotificationItem {
  final IconData icon;
  final Color color;
  final Color bgColor;
  final String title;
  final String description;

  _NotificationItem({
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.title,
    required this.description,
  });
}

class _NotificationListCard extends StatelessWidget {
  final _NotificationItem item;

  const _NotificationListCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 9, bottom: 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            margin: const EdgeInsets.only(right: 12, top: 3),
            decoration: BoxDecoration(
              color: item.bgColor,
              shape: BoxShape.circle,
            ),
            child:
                Center(child: FaIcon(item.icon, color: item.color, size: 18)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 3),
                Text(item.description,
                    style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
