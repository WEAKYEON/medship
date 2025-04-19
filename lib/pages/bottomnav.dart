import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:medship/pages/allchat.dart';
import 'package:medship/pages/hospital.dart';
import 'package:medship/pages/home.dart';
import 'package:medship/pages/login.dart';
import 'package:medship/pages/profile.dart';

class BottomNav extends StatefulWidget {
  final int initialIndex;
  const BottomNav({super.key, this.initialIndex = 0});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTabIndex = 0;

  late List<Widget> pages;
  late Widget currentPage;
  late Home homepage;
  late Profile profile;
  late Hospital hospital;
  late ChatSelectionPage chat;
  late LogIn login;

  @override
  void initState() {
    homepage = Home();
    profile = Profile();
    hospital = Hospital();
    chat = ChatSelectionPage();
    login = LogIn();
    pages = [homepage, hospital, chat, profile];
    currentTabIndex = widget.initialIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: Colors.white,
        color: Colors.blueAccent,
        animationDuration: Duration(milliseconds: 500),
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        items: [
          Icon(Icons.home_outlined, color: Colors.white),
          Icon(Icons.local_hospital_outlined, color: Colors.white),
          Icon(Icons.chat_bubble_outline, color: Colors.white),
          Icon(Icons.person_outline, color: Colors.white),
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
