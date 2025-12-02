class NewsArticle {
  final String title;
  final String description;
  final String url;
  final String? urlToImage;
  final String source;
  final DateTime publishedAt;
  final String? author;

  NewsArticle({
    required this.title,
    required this.description,
    required this.url,
    this.urlToImage,
    required this.source,
    required this.publishedAt,
    this.author,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'],
      source: json['source']['name'] ?? 'Unknown Source',
      publishedAt: DateTime.parse(json['publishedAt']),
      author: json['author'],
    );
  }

  String get timeAgo {
    final difference = DateTime.now().difference(publishedAt);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit yang lalu';
    } else {
      return 'Baru saja';
    }
  }
}

class NewsResponse {
  final List<NewsArticle> articles;
  final int totalResults;

  NewsResponse({
    required this.articles,
    required this.totalResults,
  });

  factory NewsResponse.fromJson(Map<String, dynamic> json) {
    return NewsResponse(
      articles: (json['articles'] as List)
          .map((article) => NewsArticle.fromJson(article))
          .toList(),
      totalResults: json['totalResults'] ?? 0,
    );
  }
}
