class Verse {
  final int verse;
  final String text;

  Verse({required this.verse, required this.text});

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      verse: int.tryParse(json['verse'].toString()) ?? 0,
      text: json['text'] ?? '',
    );
  }
}
