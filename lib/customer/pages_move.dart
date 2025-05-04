import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:house_cleaners_app/customer/customer_home/customer_home_page.dart';
import 'package:house_cleaners_app/customer/customer_home/customer_massage.dart';
import 'package:house_cleaners_app/customer/customer_home/customer_profile.dart';
import 'package:house_cleaners_app/customer/customer_home/hire_cleaners.dart';

class PagesMove extends StatefulWidget {
  const PagesMove({super.key});

  @override
  State<PagesMove> createState() => _PagesMoveState();
}

class _PagesMoveState extends State<PagesMove> {

  int _selectedIndex = 0;
  final List<Widget> _pages = [
    CustomerHomePage(),
    HireCleaners(),
    CustomerMassage(),
    CustomerProfile(),
  ];

  final List<Widget> items = [
    Icon(Icons.home),
    Icon(Icons.edit_calendar_rounded),
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
