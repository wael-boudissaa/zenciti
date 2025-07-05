import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:zenciti/app/config/theme.dart';

class AppBarHome extends StatelessWidget implements PreferredSizeWidget {
  final String? username;
  final String? avatarUrl;
  final int notificationCount;

  const AppBarHome({
    super.key,
    this.username = "Wael",
    this.avatarUrl =
        "https://docs.flutter.dev/assets/images/dash/dash-fainting.gif",
    this.notificationCount = 5,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 2,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome back,',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            username ?? "",
            style: const TextStyle(
              color: AppColors.greenPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.mapLocationDot,
            color: AppColors.greenPrimary,
            size: 22,
          ),
          tooltip: "View Map",
          onPressed: () {
            context.push('/map');
          },
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: const FaIcon(
                FontAwesomeIcons.bell,
                color: AppColors.greenPrimary,
                size: 22,
              ),
              tooltip: "Notifications",
              onPressed: () {
                context.push('/notification');
              },
            ),
            if (notificationCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    notificationCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: GestureDetector(
            onTap: () {
              context.push('/profile/$username');
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(avatarUrl ?? ""),
              radius: 21,
            ),
          ),
        ),
      ],
    );
  }
}
