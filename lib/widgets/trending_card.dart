import 'package:flutter/material.dart';
import 'package:newzshots/model/article.dart';

class TrendingCard extends StatelessWidget {
  final Article trending;
  const TrendingCard({Key? key, required this.trending}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Image.network(
            trending.urlToImage,
          ),
          ListTile(
            leading: Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                    trending.sourceName.contains('.com')
                        ? 'https://newzshots.herokuapp.com/img/${trending.sourceName.replaceAll(" ", '')}'
                        : 'https://newzshots.herokuapp.com/img/${trending.sourceName.replaceAll(" ", '')}.com',
                  ),
                ),
              ),
            ),
            title: Text(trending.title),
            subtitle: Text(
              'Author - ${trending.author}',
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              ' ${trending.description}',
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  // Perform some action
                },
                child: const Text('open'),
              ),
              TextButton(
                onPressed: () {
                  // Perform some action
                },
                child: const Text('goto'),
              ),
              TextButton(
                onPressed: () {
                  // Perform some action
                },
                child: const Text('share'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
