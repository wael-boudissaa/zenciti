import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

    return SafeArea(
      child: Material(
        elevation: 2,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: Colors.white,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(
                  FontAwesomeIcons.arrowLeft,
                  color: Colors.grey,
                ),
                onPressed: () => context.pop(),
              ),
      
              // Search Bar
              Expanded(
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        hintText: 'Search for activities',
                        hintStyle: const TextStyle(fontSize: 14),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Icon(
                            FontAwesomeIcons.search,
                            color: Colors.grey[400],
                            size: 18,
                          ),
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 0,
                          minHeight: 0,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      
              const SizedBox(width: 10),
      
              // Location Icon with Badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.locationDot,
                      color: Colors.black87,
                      size: 20,
                    ),
                    onPressed: () {
                      // TODO: implement location action
                    },
                  ),
                  Positioned(
                    right: 6,
                    top: 5,
                    child: Container(
                      height: 16,
                      width: 16,
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          "2",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      
              // Bell Icon
              IconButton(
                icon: const Icon(
                  FontAwesomeIcons.bell,
                  color: Colors.black87,
                  size: 20,
                ),
                onPressed: () {
                  // TODO: implement notifications action
                },
              ),
      
              // Profile Avatar
              _buildProfileAvatar(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: GestureDetector(
        onTap: () {
          // TODO: Navigate to profile/settings
        },
        child: CircleAvatar(
          radius: 18,
          backgroundColor: theme.primaryColor,
          backgroundImage: const NetworkImage(
            'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif',
          ),
        ),
      ),
    );
  }
}

