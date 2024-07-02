import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:egypttourguide/Screens/about.dart';
import 'package:egypttourguide/Screens/contact.dart';
import 'package:egypttourguide/Screens/home_screen.dart';
import 'package:egypttourguide/Screens/profile.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  final List<Widget> _navigationItem = [
    const HomeScreen(),
    const About(),
    const Contact(),
    const Profile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _navigationItem[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        buttonBackgroundColor: const Color.fromARGB(255, 1, 61, 58),
        backgroundColor: Colors.transparent,
        color: const Color.fromARGB(255, 1, 61, 58),
        items: const [
          Icon(
            Icons.home,
            color: Colors.white,
          ),
          Icon(
            Icons.help,
            color: Colors.white,
          ),
          Icon(
            Icons.contact_mail,
            color: Colors.white,
          ),
          Icon(
            Icons.account_circle,
            color: Colors.white,
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
