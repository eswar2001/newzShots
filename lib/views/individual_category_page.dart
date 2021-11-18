import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:newzshots/model/category.dart';
import 'package:newzshots/widgets/ctrending_card.dart';

class IndividualViewCategortPage extends StatefulWidget {
  final String url;
  const IndividualViewCategortPage({Key? key, required this.url})
      : super(key: key);

  @override
  _IndividualViewCategortPageState createState() =>
      _IndividualViewCategortPageState();
}

class _IndividualViewCategortPageState
    extends State<IndividualViewCategortPage> {
  @override
  Widget build(BuildContext context) {
    //print(widget.url);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
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
        title: Text(
          widget.url.replaceAll('/category/', '').toUpperCase(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.deepOrange,
      ),
      body: IndividualCategortPage(url: widget.url),
    );
  }
}

class IndividualCategortPage extends StatefulWidget {
  final String url;
  const IndividualCategortPage({Key? key, required this.url}) : super(key: key);

  @override
  _IndividualCategortPageState createState() => _IndividualCategortPageState();
}

class _IndividualCategortPageState extends State<IndividualCategortPage> {
  bool isLoading = true;

  bool isSearching = false;
  final ScrollController _scrollController = ScrollController();
  List<CArticle> _foundArticles = [];
  List<CArticle> articles = [];
  getData() async {
    articles = [];
    try {
      var response =
          await http.get(Uri.https('newzshots.herokuapp.com', widget.url));
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;

        var itemCount = jsonResponse['count-articles'];
        articles.addAll(jsonResponse['data']
            .map<CArticle>((i) => CArticle.fromJson(i))
            .toList());
        if (mounted) {
          setState(() {
            isLoading = false;
            _foundArticles = articles;
          });
        }
        //print('Number of articles about http: $itemCount.');
      } else {
        //print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      //print(e);
    }
  }

  void _runFilter(String enteredKeyword) {
    List<CArticle> results = [];
    if (enteredKeyword.isEmpty) {
      results = articles;
    } else {
      results = articles
          .where((user) =>
              user.title.toLowerCase().contains(enteredKeyword.toLowerCase()) ||
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
          if (isSearching) await  getData();
          await Future.delayed(const Duration(seconds: 3));
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
                          .map((e) => CTrendingCard(
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
