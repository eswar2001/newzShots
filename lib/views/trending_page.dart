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
  ScrollController _scrollController = new ScrollController();
  List<Article> articles = [];
  getData() async {
    try {
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
      return ListView(
        controller: _scrollController,
        addAutomaticKeepAlives: true,
        children: articles
            .map((e) => TrendingCard(
                  trending: e,
                ))
            .toList(),
      );
    }
  }
}
