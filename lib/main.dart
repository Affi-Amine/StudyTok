import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/fyp_screen.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Custom NavBar Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _page = 0; // Default page index

  // Define your screens
  final List<Widget> _screens = [
    FYPScreen(),
    Leaderboard(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[
          _page], // Display the screen corresponding to the selected tab
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.black, width: 2), // Top divider
          ),
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: 40), // Adjust padding to limit divider width
        child: BottomNavigationBar(
          currentIndex: _page,
          onTap: (index) {
            setState(() {
              _page = index; // Change the page index on button tap
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: _buildIconWithUnderline(Icons.home_outlined, 0),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _buildIconWithUnderline(Icons.emoji_events_outlined, 1),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _buildIconWithUnderline(Icons.person_outline, 2),
              label: '',
            ),
          ],
          backgroundColor:
              Colors.white, // Make the background of the navbar transparent
          type: BottomNavigationBarType
              .fixed, // Prevents shifting when selecting items
          selectedItemColor: Colors.black, // Color for the active icon
          unselectedItemColor: Colors.grey, // Color for the inactive icons
          showSelectedLabels: false, // Hide labels
          showUnselectedLabels: false, // Hide labels
          elevation: 0, // Remove shadow below the navbar
        ),
      ),
    );
  }

  // Helper method to build icons with underline for the active icon
  Widget _buildIconWithUnderline(IconData icon, int index) {
    bool isSelected = _page == index;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 35, // Increased icon size
          color:
              isSelected ? Colors.black : Colors.grey, // Active/inactive color
        ),
        if (isSelected)
          Container(
            margin: const EdgeInsets.only(top: 4),
            height: 2,
            width: 25,
            color: Colors.black, // Black underline for the selected icon
          ),
      ],
    );
  }
}
