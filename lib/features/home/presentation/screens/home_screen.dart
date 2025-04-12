import 'package:flutter/material.dart';
import 'package:zenciti/features/home/presentation/widgets/navigation_bar.dart';


class HomePage extends StatefulWidget {
   HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Center(child: Text('Home')), Center(child: Text('Browse')),
    Center(child: Text('Radio')),
    Center(child: Text('Library')),
    Center(child: Text('Search')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar:NavigationBarW(
        index: _currentIndex,
        onChange: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
