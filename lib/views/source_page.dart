import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newzshots/views/generic_view_articles.dart';

class SourcePage extends StatefulWidget {
  const SourcePage({Key? key}) : super(key: key);

  @override
  _SourcePageState createState() => _SourcePageState();
}

class _SourcePageState extends State<SourcePage> {
  bool isLoading = true;
  List<dynamic> source = [];
  getData() async {
    var response =
        await http.get(Uri.https('newzshots.herokuapp.com', '/sources'));
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as List<dynamic>;
      source.addAll(jsonResponse);
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      print('Number of articles about http: ${jsonResponse.length}.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
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
            itemCount: source.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) =>
                          GenericViewPage(url: '/source/${source[index]}'),
                    ),
                  );
                },
                child: Card(
                  color: Colors.amber,
                  child: Center(
                    child: Image.network(
                        'https://newzshots.herokuapp.com/img/${source[index]}'),
                  ),
                ),
              );
            }),
      );
    }
  }
}
