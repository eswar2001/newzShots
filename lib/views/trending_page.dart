import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newzshots/model/article.dart';
import 'package:newzshots/widgets/trending_card.dart';

class TrendingPage extends StatefulWidget {
  const TrendingPage({Key? key}) : super(key: key);

  @override
  _TrendingPageState createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  bool isLoading = true;
  bool isSearching = false;
  final ScrollController _scrollController = ScrollController();
  List<Article> articles = [];
  List<Article> _foundArticles = [];
  getData() async {
    try {
      articles = [];
      var response =
          await http.get(Uri.https('newzshots.herokuapp.com', '/headlines'));
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        var itemCount = jsonResponse['length'];
        articles.addAll(jsonResponse['articles']
            .map<Article>((i) => Article.fromJson(i))
            .toList());
        if (mounted) {
          setState(() {
            isLoading = false;
            _foundArticles = articles;
          });
        }
        // print('Number of articles about http: $itemCount.');
      } else {
        // print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      // print(e);
    }
  }

  void _runFilter(String enteredKeyword) {
    List<Article> results = [];
    if (enteredKeyword.isEmpty) {
      results = articles;
    } else {
      results = articles
          .where((user) =>
              user.content
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              user.description
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundArticles = results;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return RefreshIndicator(
        onRefresh: () async {
          setState(() {
            isLoading = true;
          });
          await getData();
          isSearching = !isSearching;
          // await Future.delayed(const Duration());
          setState(() {
            isLoading = false;
          });
        },
        child: Column(
          children: [
            isSearching
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value) => _runFilter(value),
                      decoration: const InputDecoration(
                        labelText: 'Search',
                        suffixIcon: Icon(Icons.search),
                      ),
                    ),
                  )
                : SizedBox(),
            Expanded(
              child: _foundArticles.isNotEmpty
                  ? ListView(
                      controller: _scrollController,
                      addAutomaticKeepAlives: true,
                      children: _foundArticles
                          .map((e) => TrendingCard(
                                trending: e,
                              ))
                          .toList(),
                    )
                  : const Text(
                      'No results found',
                      style: TextStyle(fontSize: 24),
                    ),
            ),
          ],
        ),
      );
    }
  }
}
