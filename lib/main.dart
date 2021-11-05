import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:newzshots/views/location_page.dart';
import 'package:newzshots/views/source_page.dart';
import 'package:newzshots/views/trending_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'NewzShots',
      debugShowCheckedModeBanner: false,
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  int _currentIndex = 0;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            children: <Widget>[
              const TrendingPage(),
              const LocationPage(),
              const SourcePage(),
              Container(
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        backgroundColor: Colors.white,
        selectedIndex: _currentIndex,
        showElevation: true, // use this to remove appBar's elevation
        onItemSelected: (index) => setState(() {
          _currentIndex = index;
          _pageController.animateToPage(index,
              duration: const Duration(milliseconds: 300), curve: Curves.ease);
        }),
        items: [
          BottomNavyBarItem(
            icon: const Icon(Icons.trending_up_rounded),
            title: const Text(
              'Article',
              style: TextStyle(color: Colors.black),
            ),
            activeColor: Colors.redAccent,
          ),
          BottomNavyBarItem(
              icon: const Icon(Icons.location_city_rounded),
              title: const Text('Location'),
              activeColor: Colors.black),
          BottomNavyBarItem(
              icon: const Icon(Icons.source_rounded),
              title: const Text('Source'),
              activeColor: Colors.black),
          BottomNavyBarItem(
              icon: const Icon(Icons.settings),
              title: const Text(
                'Settings',
              ),
              activeColor: Colors.black),
        ],
      ),
    );
  }
}
