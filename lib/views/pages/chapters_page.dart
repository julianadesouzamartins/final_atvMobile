import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/models/book_model.dart';
import 'package:myapp/views/pages/verses_page.dart';

class ChaptersPage extends StatefulWidget {
  final Book book;

  const ChaptersPage({Key? key, required this.book}) : super(key: key);

  @override
  _ChaptersPageState createState() => _ChaptersPageState();
}

class _ChaptersPageState extends State<ChaptersPage> {
  @override
  void initState() {
    super.initState();
    print('ChaptersPage initialized. Book abbreviation: ${widget.book.abbrev}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.book.name ?? 'Capítulos')),
      body: ListView.builder(
        itemCount: 150, // Número alto para cobrir livros longos como Salmos
        itemBuilder: (context, index) {
          final chapterNumber = index + 1;
          return ListTile(
            title: Text('Capítulo $chapterNumber'),
            onTap: () {
              print('Chapter tapped: $chapterNumber');
              if (widget.book.abbrev != null &&
                  widget.book.abbrev!.isNotEmpty) {
                Get.to(
                  () => VersesPage(
                    bookAbbrev: widget.book.abbrev!,
                    chapter: chapterNumber,
                  ),
                );
              } else {
                print('Book abbreviation is empty or null for navigation');
                Get.snackbar(
                  'Erro',
                  'Abreviação do livro não encontrada.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.redAccent,
                  colorText: Colors.white,
                );
              }
            },
          );
        },
      ),
    );
  }
}
