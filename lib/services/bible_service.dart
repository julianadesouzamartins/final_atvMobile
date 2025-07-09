import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myapp/models/book_model.dart'; // Modelo Book
import 'package:myapp/models/verse_model.dart'; // Modelo Verse

class BibleService {
  static const String _baseUrl = 'https://bible4u.net/api/v1';

  // Método para buscar a lista de traduções bíblicas
  Future<List<dynamic>> fetchBibles() async {
    final response = await http.get(Uri.parse('$_baseUrl/bibles'));

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      return decodedData;
    } else {
      throw Exception('Falha ao carregar as traduções da Bíblia');
    }
  }

  // Método para buscar a lista de livros da Bíblia
  Future<List<Book>> fetchBooks() async {
    // TODO: Implementar a busca de livros para uma tradução específica (ex: 'acf' ou 'nvi')
    // A URL correta deve ser algo como '$_baseUrl/bibles/acf/books'
    final response = await http.get(Uri.parse('$_baseUrl/bibles/AA/books'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedData = json.decode(response.body);
      return (decodedData['data'] as List)
          .map((dynamic item) => Book.fromJson(item))
          .toList();
    } else {
      throw Exception('Falha ao carregar os livros da Bíblia');
    }
  }

  // Método para buscar os versículos de um capítulo específico
  Future<List<Verse>> fetchChapter(String bookAbbrev, int chapter) async {
    final url =
        '$_baseUrl/passage/AA/$bookAbbrev?start-chapter=$chapter&end-chapter=$chapter';
    print('Fetching chapter from URL: $url'); // Print the URL
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedData = json.decode(response.body);
      final List<dynamic> versesData = decodedData['data']['verses'];
      return versesData.map((dynamic item) => Verse.fromJson(item)).toList();
    } else if (response.statusCode == 404) {
      throw Exception('Capítulo não encontrado');
    } else {
      throw Exception('Falha ao carregar o capítulo');
    }
  }
}
