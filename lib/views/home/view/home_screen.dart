import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _currentIndex = 0;
  

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
    Center(child: Image.asset('assets/images/images.png'),),
    Center(child: Image.asset('assets/images/images.png'),),
    const SettingScreen(),
    const ProfileScreen(),
  ];

    return Scaffold(
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          /// Buddies
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Buddies"),
            selectedColor: Colors.purple,
          ),

          /// Discover
          SalomonBottomBarItem(
            icon: const Icon(Icons.favorite_border),
            title: const Text("Discover"),
            selectedColor: Colors.pink,
          ),

          /// Setting & Privacy
          SalomonBottomBarItem(
            icon: const Icon(Icons.search),
            title: const Text("Setting & Privacy"),
            selectedColor: Colors.orange,
          ),

          /// Profile
          SalomonBottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text("Profile"),
            selectedColor: Colors.teal,
          ),
        ],
      ),
      body: SafeArea(
        child: pages[_currentIndex],
      ),
    );
  }
}
