import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newzshots/views/individual_category_page.dart';

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
