class Book {
  final String name;
  final String abbrev;

  Book({required this.name, required this.abbrev});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      name: json['name'] ?? 'Nome indefinido',
      abbrev: json['ref'] ?? '',
    );
  }
}
