class Quotes {
  final int id;
  final String quote;
  final String author;
  final String createdAt;

  Quotes(
      {required this.id,
      required this.quote,
      required this.author,
      required this.createdAt});

  factory Quotes.fromJson(Map<String, dynamic> json) {
    return Quotes(
      id: json['id'],
      quote: json['quote'],
      author: json['author'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quote': quote,
      'author': author,
      'created_at': createdAt,
    };
  }
}
