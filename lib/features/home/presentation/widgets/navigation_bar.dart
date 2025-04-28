import 'package:flutter/material.dart';
import 'package:forui/widgets/bottom_navigation_bar.dart';
import 'package:forui/forui.dart';

class NavigationBarW extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChange;

  const NavigationBarW({
    super.key,
    required this.index,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) => FBottomNavigationBar(
        index: index,
        onChange: onChange,
        children:  [
FBottomNavigationBarItem(
            icon: FIcon(FAssets.icons.house),
            label: const Text('Home'),
          ),
          FBottomNavigationBarItem(
            icon: FIcon(FAssets.icons.file),
            label: Text('Statistics'),
          ),
          // FBottomNavigationBarItem(
          //   icon: FIcon(FAssets.icons.radio),
          //   label: Text('Radio'),
          // ),
          // FBottomNavigationBarItem(
          //   icon: FIcon(FAssets.icons.libraryBig),
          //   label: Text('Library'),
          // ),
          FBottomNavigationBarItem(
            icon: FIcon(FAssets.icons.user),
            label: Text('Profile'),
          ),
        ],
      );
}
