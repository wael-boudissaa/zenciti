import 'package:flutter/material.dart';
import 'package:zenciti/app/config/theme.dart';

class AppBarHome extends StatefulWidget implements PreferredSizeWidget {
  const AppBarHome({super.key});

  @override
  State<AppBarHome> createState() => _AppBarHomeState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); 
}

class _AppBarHomeState extends State<AppBarHome> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text(
        'Hello Wael',
        style: TextStyle(
          color: AppColors.greenPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              "https://docs.flutter.dev/assets/images/dash/dash-fainting.gif",
            ),
            radius: 20,
          ),
        ),
      ],
      backgroundColor: Colors.white,
      elevation: 2,
    );
  }
}
