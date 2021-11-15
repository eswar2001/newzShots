import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newzshots/model/category.dart';
import 'package:newzshots/widgets/ctrending_card.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  bool isLoading = true;
  List<dynamic> category = [];
  getData() async {
    try {
      var response =
          await http.get(Uri.https('newzshots.herokuapp.com', '/categories'));
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body) as List<dynamic>;
        category.addAll(jsonResponse);
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        //print('error');
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
      return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
          ),
          itemCount: category.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => IndividualViewCategortPage(
                        url: '/category/${category[index]}'),
                  ),
                );
              },
              child: Card(
                child: Center(
                  child: Text(
                    category[index].toString().toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }
}

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
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        title: Text(
          widget.url.replaceAll('/category/', '').toUpperCase(),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
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
  final ScrollController _scrollController = ScrollController();
  List<CArticle> articles = [];
  getData() async {
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
            .map((e) => CTrendingCard(
                  trending: e,
                ))
            .toList(),
      );
    }
  }
}
