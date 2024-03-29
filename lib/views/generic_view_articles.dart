import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newzshots/model/article.dart';
import 'package:newzshots/widgets/trending_card.dart';

class GenericViewPage extends StatefulWidget {
  final String url;
  const GenericViewPage({Key? key, required this.url}) : super(key: key);

  @override
  _GenericViewPageState createState() => _GenericViewPageState();
}

class _GenericViewPageState extends State<GenericViewPage> {
  @override
  Widget build(BuildContext context) {
    //print(widget.url);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        leading: InkWell(
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        title: const Text(
          'Results',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: GenericView(url: widget.url),
    );
  }
}

class GenericView extends StatefulWidget {
  final String url;
  const GenericView({Key? key, required this.url}) : super(key: key);

  @override
  _GenericViewState createState() => _GenericViewState();
}

class _GenericViewState extends State<GenericView> {
  bool isLoading = true;
  bool isSearching = false;
  List<Article> articles = [];
  final ScrollController _scrollController = ScrollController();
  List<Article> _foundArticles = [];
  getData() async {
    articles = [];
    var response = await http.get(
      Uri.https('newzshots.herokuapp.com', widget.url),
    );
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
      print('Number of articles about http: $itemCount.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
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
          if (isSearching) await getData();
          // await Future.delayed(const Duration(seconds: 3));
          setState(() {
            isLoading = false;
            isSearching = !isSearching;
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
                : const SizedBox(),
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
