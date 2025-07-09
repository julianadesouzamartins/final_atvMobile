import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class OpenAIService {
  static const String _baseUrl = 'https://api.openai.com/v1';

  Future<String> generateStudy(String verseText) async {
    final apiKey = _getApiKey();
    if (apiKey == null) {
      throw Exception('API key not found in .env file');
    }

    final url = Uri.parse('$_baseUrl/chat/completions');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: json.encode({
        'model': 'gpt-3.5-turbo', // ou 'gpt-4' se disponível e preferir
        'messages': [
          {
            'role': 'user',
            'content':
                'Gere um estudo bíblico detalhado para o seguinte versículo, incluindo Contexto Histórico, Aplicação Prática e Referências Cruzadas. Se houver um link externo relevante para o estudo, inclua-o no final em uma linha separada no formato "Link Externo: [URL]". Limite a resposta a no máximo 500 tokens: "$verseText"',
          },
        ],
        'max_tokens': 500,
      }),
    );

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      return decodedData['choices'][0]['message']['content'];
    } else {
      throw Exception(
        'Failed to generate study: ${response.statusCode} ${response.body}',
      );
    }
  }

  String? _getApiKey() {
    print(
      'API Key read from .env (partial): ${dotenv.env['OPENAI_API_KEY']?.substring(0, 5)}...',
    ); // Print a part of the key for verification
    return dotenv.env['OPENAI_API_KEY'];
  }
}
