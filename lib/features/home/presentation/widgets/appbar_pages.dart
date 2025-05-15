import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBarPages extends StatefulWidget implements PreferredSizeWidget {
  const AppBarPages({super.key});

  @override
  State<AppBarPages> createState() => _AppBarPagesState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarPagesState extends State<AppBarPages> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: theme.colorScheme.background,
      elevation: 2,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black, size: 22),
        tooltip: 'Go back',
        onPressed: () => context.pop(),
      ),
      actions: [
        _buildActionIcon(
          icon: Icons.map,
          tooltip: 'Open Map',
          onTap: () {
          },
        ),
        _buildActionIcon(
          icon: Icons.notifications_none_outlined,
          tooltip: 'Notifications',
          onTap: () {
          },
        ),
        _buildProfileAvatar(),
      ],
    );
  }

  Widget _buildActionIcon({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return IconButton(
      icon: Icon(icon, color: Colors.black, size: 22),
      tooltip: tooltip,
      onPressed: onTap,
    );
  }

  Widget _buildProfileAvatar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: GestureDetector(
        onTap: () {
          // TODO: Navigate to profile/settings
        },
        child: const CircleAvatar(
          radius: 18,
          backgroundImage: NetworkImage(
            'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif',
          ),
        ),
      ),
    );
  }
}

