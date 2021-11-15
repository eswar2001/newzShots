import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newzshots/model/category.dart';
import 'package:newzshots/views/webview_page.dart';
import 'package:share/share.dart';

class CTrendingCard extends StatelessWidget {
  final CArticle trending;
  const CTrendingCard({Key? key, required this.trending}) : super(key: key);

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
              : CachedNetworkImage(
                  imageUrl: trending.urlToImage,
                  imageBuilder: (context, imageProvider) => Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 3,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.contain,
                        onError: (object, stackTrace) {},
                      ),
                    ),
                  ),
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) {
                    return Container(
                      color: Colors.amber,
                      alignment: Alignment.center,
                      child: const Text(
                        'No Image to load',
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
              trending.author.isEmpty ? "" : 'Author - ${trending.author}',
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              ' ${trending.description.trimLeft()}',
              style: TextStyle(color: Colors.black),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              Text(
                'Published :${trending.publishedAt}',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => WebViewPage(
                        intUrl: trending.url,
                        title: trending.sourceName,
                      ),
                    ),
                  );
                },
                child: const Text('View'),
              ),
              TextButton(
                onPressed: () {
                  Share.share(trending.url);
                },
                child: const Text('Share'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
