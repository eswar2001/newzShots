import 'package:flutter/material.dart';
import 'package:newzshots/model/article.dart';

class TrendingCard extends StatelessWidget {
  final Article trending;
  const TrendingCard({Key? key, required this.trending}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uri = Uri.parse(trending.url);
    uri.host; // www.wikipedia.org
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          trending.urlToImage.isEmpty
              ? Image.asset(
                  'images/logo.png',
                  height: 300,
                )
              : Image.network(
                  trending.urlToImage,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.amber,
                      alignment: Alignment.center,
                      child: const Text(
                        'Whoops!',
                        style: TextStyle(fontSize: 30),
                      ),
                    );
                  },
                ),
          ListTile(
            leading: Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: trending.sourceName == "YouTube"
                      ? const NetworkImage(
                          'https://brandlogos.net/wp-content/uploads/2020/03/YouTube-icon-SVG-512x512.png')
                      : NetworkImage(
                          'https://newzshots.herokuapp.com/img/${uri.host.replaceAll('www.', '')}',
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
