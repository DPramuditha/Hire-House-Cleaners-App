import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:house_cleaners_app/house_cleaners/cleaners_dashboard.dart';
import 'package:house_cleaners_app/house_cleaners/cleaners_messages.dart';
import 'package:house_cleaners_app/house_cleaners/cleaners_profile.dart';

class CleanersHome extends StatefulWidget {
  const CleanersHome({super.key});

  @override
  State<CleanersHome> createState() => _CleanersHomeState();
}

class _CleanersHomeState extends State<CleanersHome> {

  int _selectedIndex = 0;
  final List<Widget> _pages = [
    CleanersDashboard(),
    CleanersMessages(),
    CleanersProfile(),
  ];

  final List<Widget> items = [
    Icon(Icons.home),
    Icon(Icons.message),
    Icon(Icons.account_circle),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: CurvedNavigationBar(
        color: Color(0xff503cb7),
        buttonBackgroundColor: Color(0xffffa633), 
        backgroundColor: Colors.transparent,
        height: 45,
        items: items,
        onTap: (index){
          setState(() {
            _selectedIndex = index;
          });
        },

        ),

        body: _pages[_selectedIndex],
    );
  }
}