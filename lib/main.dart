import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'screens/fyp_screen.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(ProviderScope(child: MyApp())); // Wrapping with ProviderScope
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Curved NavBar Demo',
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
    FYPScreen(), // Default home page (index 0)
    Leaderboard(), // List page (index 1)
    Profile(), // Compare page (index 2)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_page], // Display the screen corresponding to the selected tab
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white, // Changed to white
        color: Colors.lightGreen, // NavBar color (matching your tags section color)
        buttonBackgroundColor: Colors.white, // Color of the button when selected
        height: 60, // Adjust height for better appearance
        items: <Widget>[
          Icon(Icons.add, size: 30, color: Colors.black), // Icon for home
          Icon(Icons.list, size: 30, color: Colors.black), // Icon for list
          Icon(Icons.compare_arrows, size: 30, color: Colors.black), // Icon for compare
        ],
        onTap: (index) {
          setState(() {
            _page = index; // Change the page index on button tap
          });
        },
      ),
    );
  }
}