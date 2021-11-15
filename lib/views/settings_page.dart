import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isLoading = true;
  String content = "";
  String author = "";
  getData() async {
    content = "";
    author = "";
    var response = await http.get(Uri.https('api.quotable.io', '/random'));
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      content = jsonResponse['content'];
      author = jsonResponse['author'];

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      //print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              content,
              style: const TextStyle(
                  fontFamily: 'Playfair Display',
                  color: Colors.black,
                  fontSize: 30.0),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
            ),
            Text(
              '~ $author',
              style: const TextStyle(
                  fontFamily: 'Playfair Display',
                  color: Colors.black,
                  fontSize: 20.0),
            ),
            const Padding(
              padding: EdgeInsets.all(30.0),
            ),
          ],
        ),
      ),
    );
  }
}
