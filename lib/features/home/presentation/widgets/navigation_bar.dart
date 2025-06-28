import 'package:flutter/material.dart';
import 'package:forui/widgets/bottom_navigation_bar.dart';
import 'package:forui/forui.dart';

class NavigationBarW extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChange;
  final bool isAdmin;

  const NavigationBarW({
    super.key,
    required this.index,
    required this.onChange,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) => FBottomNavigationBar(
        index: index,
        onChange: onChange,
        children: [
          FBottomNavigationBarItem(
            icon: FIcon(FAssets.icons.house),
            label: const Text('Home'),
          ),
          if (isAdmin)
            FBottomNavigationBarItem(
              icon: FIcon(FAssets.icons.file),
              label: const Text('Statistics'),
            ),
          FBottomNavigationBarItem(
              icon: FIcon(FAssets.icons.chartBar),
              label: const Text("Analytics")),
          FBottomNavigationBarItem(
              icon: FIcon(FAssets.icons.qrCode), label: const Text("Scanner")),
          FBottomNavigationBarItem(
            icon: FIcon(FAssets.icons.user),
            label: const Text('Profile'),
          ),
        ],
      );
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final bool active;
  const _NavIcon(
      {required this.icon,
      required this.label,
      this.color,
      this.active = false});
  @override
  Widget build(BuildContext context) {
    final Color base =
        active ? (color ?? const Color(0xFF00674B)) : Colors.grey[400]!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: base, size: 22),
        const SizedBox(height: 2),
        Text(label,
            style: TextStyle(
                fontSize: 12,
                color: base,
                fontWeight: active ? FontWeight.w600 : FontWeight.normal)),
      ],
    );
  }
}
