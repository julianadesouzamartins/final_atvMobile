import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/controllers/auth_controller.dart';
import '/services/bible_service.dart';
import '/models/book_model.dart';
import '/views/pages/library_page.dart';
import 'chapters_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthController authController = Get.find<AuthController>();
  final BibleService bibleService = BibleService();
  late Future<List<Book>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _booksFuture = bibleService.fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Livros da Bíblia'),
        actions: [
          IconButton(
            icon: const Icon(Icons.folder_open), // Ícone de pasta/livro
            tooltip: 'Biblioteca de Estudos',
            onPressed: () {
              Get.to(() => LibraryPage()); // Navega para a LibraryPage
            },
          ),
          Obx(
            () =>
                authController.isLoading.value
                    ? const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    )
                    : IconButton(
                      icon: const Icon(Icons.exit_to_app),
                      tooltip: 'Logout',
                      onPressed: () {
                        authController.logout();
                      },
                    ),
          ),
        ],
      ),
      body: FutureBuilder<List<Book>>(
        future: _booksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum livro encontrado.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final book = snapshot.data![index];
                return ListTile(
                  title: Text(book.name),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // ✅ Agora navega para a tela de capítulos
                    Get.to(() => ChaptersPage(book: book));
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
