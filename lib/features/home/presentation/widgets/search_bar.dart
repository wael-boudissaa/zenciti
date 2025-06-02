import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class SearchBarHome extends StatefulWidget {
  const SearchBarHome({super.key});

  @override
  State<SearchBarHome> createState() => _SearchBarHomeState();
}

class _SearchBarHomeState extends State<SearchBarHome> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Stack(
        children: [
          TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              hintText: 'Search for activities',
              hintStyle: const TextStyle(fontSize: 14),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 12, right: 8),
                child: Icon(FontAwesomeIcons.search, color: Colors.grey),
              ),
              prefixIconConstraints:
                  const BoxConstraints(minWidth: 0, minHeight: 0),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    // Handle filter action
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(FontAwesomeIcons.locationDot,
                        color: Colors.black87, size: 18),
                  ),
                ),
                InkWell(
                    onTap: () {
                        context.push('/notification');
                    },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(FontAwesomeIcons.bell,
                        color: Colors.black87, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
