import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newzshots/views/generic_view_articles.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  bool isLoading = true;
  List<dynamic> countries = [];
  getData() async {
    var response =
        await http.get(Uri.https('newzshots.herokuapp.com', '/countries'));
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as List<dynamic>;
      countries.addAll(jsonResponse);
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
            itemCount: countries.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) =>
                          GenericViewPage(url: '/country/${countries[index]}'),
                    ),
                  );
                },
                child: Card(
                  color: Colors.amber,
                  child: Center(
                    child: Image.network(
                        'https://flagcdn.com/48x36/${countries[index]}.png'),
                  ),
                ),
              );
            }),
      );
    }
  }
}
