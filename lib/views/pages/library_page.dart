import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/study_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myapp/views/pages/study_detail_page.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  late Future<List<Study>> _studiesFuture;

  @override
  void initState() {
    super.initState();
    _studiesFuture = _loadStudies();
  }

  Future<List<Study>> _loadStudies() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Usuário não autenticado.');
    }

    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('studies')
            .orderBy('createdAt', descending: true)
            .get();

    return snapshot.docs.map((doc) => Study.fromJson(doc.data())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estudos Salvos')),
      body: FutureBuilder<List<Study>>(
        future: _studiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final studies = snapshot.data ?? [];

          if (studies.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum estudo salvo encontrado.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: studies.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final study = studies[index];

              // Formatar a data de forma segura
              String formattedDate = 'Data desconhecida';
              try {
                formattedDate = DateFormat(
                  'dd/MM/yyyy HH:mm',
                ).format(study.createdAt);
              } catch (_) {}

              return ListTile(
                leading: const Icon(
                  Icons.menu_book_rounded,
                  color: Colors.indigo,
                ),
                title: Text(
                  study.verse,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Salvo em: $formattedDate'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Get.to(
                    () => StudyDetailPage(
                      verseText: study.verse,
                      studyText: study.studyText,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
