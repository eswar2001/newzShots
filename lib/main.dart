import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:newzshots/views/category_page.dart';
import 'package:newzshots/views/location_page.dart';
import 'package:newzshots/views/settings_page.dart';
import 'package:newzshots/views/source_page.dart';
import 'package:newzshots/views/trending_page.dart';

void main() {
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NewzShots',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        brightness: Brightness.light,
      ),
      home: const MyHome(),
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
  final PageController _pageController = PageController();

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
            children: const <Widget>[
              TrendingPage(),
              LocationPage(),
              SourcePage(),
              CategoriesPage(),
              SettingsPage()
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        backgroundColor: Colors.white,
        selectedIndex: _currentIndex,
        onItemSelected: (index) => setState(
          () {
            _currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          },
        ),
        items: [
          BottomNavyBarItem(
            icon: const Icon(Icons.trending_up_rounded),
            title: const Text(
              'Trending',
              style: TextStyle(color: Colors.black),
            ),
            activeColor: Colors.redAccent,
          ),
          BottomNavyBarItem(
              icon: const Icon(Icons.location_on_rounded),
              title: const Text('Location'),
              activeColor: Colors.black),
          BottomNavyBarItem(
              icon: const Icon(Icons.tv_rounded),
              title: const Text('Source'),
              activeColor: Colors.black),
          BottomNavyBarItem(
              icon: const Icon(Icons.category_rounded),
              title: const Text('Category'),
              activeColor: Colors.black),
          BottomNavyBarItem(
              icon: const Icon(Icons.format_quote_rounded),
              title: const Text(
                'Quote',
              ),
              activeColor: Colors.black),
        ],
      ),
    );
  }
}
