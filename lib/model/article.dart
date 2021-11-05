class Article {
  final String sourceName;
  final String title;
  final String author;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String content;

  Article(
      {required this.sourceName,
      required this.title,
      required this.author,
      required this.description,
      required this.url,
      required this.urlToImage,
      required this.publishedAt,
      required this.content});

  Article.fromJson(Map<String, dynamic> json)
      : sourceName = json['source']['name'].replaceAll(" ", ''),
        title = json['title'],
        author = json['author'],
        description = json['description'],
        publishedAt = json['publishedAt'],
        url = json['url'],
        content = json['content'],
        urlToImage = json['urlToImage'];

  Map<String, dynamic> toJson() => {
        'sourceName': sourceName.replaceAll(" ", ''),
        'title': title,
        'author': author,
        'description': description,
        'url': url,
        'urlToImage': urlToImage,
        'publishedAt': publishedAt,
        'content': content,
      };
}
