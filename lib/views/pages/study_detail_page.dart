import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:myapp/models/study_model.dart';

class StudyDetailPage extends StatefulWidget {
  final String verseText;
  final String studyText;

  const StudyDetailPage({
    Key? key,
    required this.verseText,
    required this.studyText,
  }) : super(key: key);

  @override
  _StudyDetailPageState createState() => _StudyDetailPageState();
}

class _StudyDetailPageState extends State<StudyDetailPage> {
  late String _modifiedStudyText;

  @override
  void initState() {
    super.initState();
    _modifiedStudyText = widget.studyText;
  }

  // Mapeamento de marcadores de seção para ícones
  final Map<String, IconData> sectionIcons = {
    'Introdução': Icons.info_outline,
    'Contexto Histórico': Icons.history,
    'Aplicação Prática': Icons.lightbulb_outline,
    'Referência Cruzadas': Icons.compare_arrows,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Estudo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.verseText,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 15),

              // Mostra seções formatadas
              ..._parseStudyText(_modifiedStudyText).entries.map((entry) {
                if (entry.value.trim().isEmpty && entry.key != 'Introdução') {
                  return const SizedBox.shrink();
                }

                // Obtém o ícone correspondente à seção
                final icon =
                    sectionIcons[entry.key] ?? Icons.article; // Ícone padrão

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Não exibe o título "Introdução:" se o conteúdo estiver vazio
                    if (entry.key != 'Introdução' ||
                        entry.value.trim().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Row(
                          // Usamos Row para alinhar ícone e texto
                          children: [
                            Icon(
                              icon,
                              size: 20, // Tamanho do ícone
                              color:
                                  Theme.of(context)
                                      .colorScheme
                                      .secondary, // Cor suave para o ícone
                            ),
                            const SizedBox(
                              width: 8,
                            ), // Espaço entre ícone e texto
                            Expanded(
                              // Para evitar overflow de texto
                              child: Text(
                                '${entry.key}:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color:
                                      Theme.of(context)
                                          .colorScheme
                                          .primary, // Cor suave para o título
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Text(
                      entry.value.trim(),
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 12),
                    if (entry.key !=
                            _parseStudyText(
                              _modifiedStudyText,
                            ).entries.last.key ||
                        entry.value.trim().isNotEmpty)
                      const Divider(),
                    const SizedBox(height: 8),
                  ],
                );
              }).toList(),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user == null) {
                    Get.snackbar(
                      'Erro',
                      'Usuário não autenticado.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  try {
                    final study = Study(
                      verse: widget.verseText,
                      studyText: widget.studyText,
                      createdAt: DateTime.now(),
                    );

                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .collection('studies')
                        .add(study.toJson());

                    Get.snackbar(
                      'Sucesso',
                      'Estudo salvo com sucesso!',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  } catch (e) {
                    Get.snackbar(
                      'Erro',
                      'Falha ao salvar o estudo: $e',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },
                child: const Text('Salvar Estudo'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Quebra o estudo em seções nomeadas
  Map<String, String> _parseStudyText(String studyText) {
    final Map<String, String> sections = {};
    final List<String> sectionMarkers = [
      'Contexto Histórico:',
      'Aplicação Prática:',
      'Referência Cruzadas:',
    ];

    String currentSection = 'Introdução';
    sections[currentSection] = '';

    for (final line in studyText.split('\n')) {
      final trimmed = line.trim();
      bool foundMarker = false;

      for (final marker in sectionMarkers) {
        if (trimmed.startsWith(marker)) {
          currentSection = marker.replaceAll(':', '').trim();
          sections[currentSection] = '';
          foundMarker = true;
          break;
        }
      }

      if (!foundMarker) {
        sections[currentSection] = (sections[currentSection] ?? '') + '$line\n';
      }
    }

    return sections;
  }
}
