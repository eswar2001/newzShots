class CArticle {
  final String author;
  final String description;
  final String urlToImage;
  final String url;
  final String title;
  final String publishedAt;
  final String sourceName;

  CArticle(
      {required this.author,
      required this.description,
      required this.urlToImage,
      required this.url,
      required this.title,
      required this.publishedAt,
      required this.sourceName});
  CArticle.fromJson(Map<String, dynamic> json)
      : author = json['author'] ?? '',
        description = json['description'] ?? '',
        publishedAt = json['time'] ?? '',
        sourceName = Uri.parse(json['read-more']).host.replaceAll('wwww.', ''),
        title = json['title'] ?? '',
        url = json["read-more"] != null ? json['read-more'] : '',
        urlToImage = json['images'] ?? '';
}
