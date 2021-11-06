import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

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
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        elevation: 0.3,
        toolbarHeight: 60,
        centerTitle: true,
        title: const Text(
          'About',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: ListTile(
          title: Text(content),
          subtitle: Text(author),
        ),
      ),
    );
  }
}
