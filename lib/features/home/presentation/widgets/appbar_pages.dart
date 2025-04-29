
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zenciti/app/config/theme.dart';

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
    return AppBar(
      automaticallyImplyLeading: false,
      leading:  IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 20),
            onPressed: () {
                context.go('/home');
            }),
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
