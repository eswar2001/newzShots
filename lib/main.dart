import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newzshots/views/category_page.dart';
import 'package:newzshots/views/location_page.dart';
import 'package:newzshots/views/settings_page.dart';
import 'package:newzshots/views/source_page.dart';
import 'package:newzshots/views/trending_page.dart';
import 'package:newzshots/views/webview_page.dart';

void main() {
  runApp(MyApp());
}

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
        visualDensity: VisualDensity.compact,
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

  List<String> titles = [
    'Trending',
    'Location',
    'Source',
    'Categories',
    'Quote'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: const Color(0xaaffffff),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'NewzShots - ',
              style: TextStyle(color: Colors.black),
            ),
            Text(
              titles[_currentIndex],
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                  color: Colors.black),
            ),
          ],
        ),
        elevation: 0,
        actions: [
          InkWell(
            child: IconButton(
              icon: const Icon(
                Icons.star,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const WebViewPage(
                      intUrl: 'https://github.com/eswar2001/newzShots',
                      title: 'Github',
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
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
              style: TextStyle(color: Colors.red),
            ),
            activeColor: Colors.red,
          ),
          BottomNavyBarItem(
            icon: const Icon(
              Icons.location_on_rounded,
              color: Colors.black,
            ),
            title: const Text(
              'Location',
              style: TextStyle(color: Colors.black),
            ),
            activeColor: Colors.black,
          ),
          BottomNavyBarItem(
              icon: const Icon(
                Icons.tv_rounded,
                color: Colors.black,
              ),
              title: const Text(
                'Source',
                style: TextStyle(color: Colors.black),
              ),
              activeColor: Colors.black),
          BottomNavyBarItem(
              icon: const Icon(
                Icons.category_rounded,
                color: Colors.black,
              ),
              title: const Text(
                'Category',
                style: TextStyle(color: Colors.black),
              ),
              activeColor: Colors.black),
          BottomNavyBarItem(
              icon: const Icon(
                Icons.format_quote_rounded,
                color: Colors.black,
              ),
              title: const Text(
                'Quote',
                style: TextStyle(color: Colors.black),
              ),
              activeColor: Colors.black),
        ],
      ),
    );
  }
}
