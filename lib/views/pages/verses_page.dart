import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/services/bible_service.dart';
import 'package:myapp/models/verse_model.dart';
import 'package:myapp/services/openai_service.dart';
import 'package:myapp/views/pages/study_detail_page.dart';

class VersesPage extends StatefulWidget {
  final String bookAbbrev;
  final int chapter;

  const VersesPage({Key? key, required this.bookAbbrev, required this.chapter})
    : super(key: key);

  @override
  _VersesPageState createState() => _VersesPageState();
}

class _VersesPageState extends State<VersesPage> {
  late Future<List<Verse>> _versesFuture;
  bool _isGeneratingStudy = false; // Flag para controlar múltiplos toques

  @override
  void initState() {
    super.initState();
    _versesFuture = _loadVerses();
  }

  Future<List<Verse>> _loadVerses() async {
    try {
      final List<Verse> verses = await BibleService().fetchChapter(
        widget.bookAbbrev,
        widget.chapter,
      );
      print('Number of verses loaded: ${verses.length}');
      return verses;
    } catch (e) {
      print('Erro ao carregar versículos: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.bookAbbrev.toUpperCase()} - Capítulo ${widget.chapter}',
        ),
      ),
      body: FutureBuilder<List<Verse>>(
        future: _versesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            Get.snackbar(
              'Erro',
              'Não foi possível carregar os versículos.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else {
            final verses = snapshot.data ?? [];

            if (verses.isEmpty) {
              return const Center(child: Text('Nenhum versículo encontrado.'));
            }

            return ListView.builder(
              itemCount: verses.length,
              itemBuilder: (context, index) {
                final verse = verses[index];
                return ListTile(
                  title: Text('${verse.verse}. ${verse.text}'),
                  onTap: () async {
                    if (_isGeneratingStudy) return; // Bloqueia múltiplos toques

                    setState(() {
                      _isGeneratingStudy = true;
                    });

                    Get.dialog(
                      const Center(child: CircularProgressIndicator()),
                      barrierDismissible: false,
                    );

                    try {
                      final study = await OpenAIService().generateStudy(
                        '${verse.verse}. ${verse.text}',
                      );
                      Get.back(); // Fecha loading

                      setState(() {
                        _isGeneratingStudy = false;
                      });

                      Get.to(
                        () => StudyDetailPage(
                          studyText: study,
                          verseText: '${verse.verse}. ${verse.text}',
                        ),
                      );
                    } catch (e) {
                      Get.back(); // Fecha loading em caso de erro

                      setState(() {
                        _isGeneratingStudy = false;
                      });

                      Get.snackbar(
                        'Erro ao gerar estudo',
                        'Não foi possível gerar o estudo para o versículo: $e',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                      print('Error generating study: $e');
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
