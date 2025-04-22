import 'dart:async';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:midterm_exam/models/author.dart';
import 'package:midterm_exam/models/book.dart';
import 'package:midterm_exam/pages/book_page.dart';
import 'package:midterm_exam/services/db_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Book> books = [];

  StreamSubscription? booksStream;
  @override
  void initState() {
    super.initState();
    booksStream = DBService.db.books
        .buildQuery<Book>()
        .watch(fireImmediately: true)
        .listen((data) {
          setState(() {
            books = data;
          });
        });
    initDummyData();
  }

  @override
  void dispose() {
    booksStream?.cancel();
    super.dispose();
  }

  Future<void> initDummyData() async {
    final hasAuthor = await DBService.db.authors.count() > 0;
    if (!hasAuthor) {
      final author = Author(name: "Gesang", hometown: "Lumajang");
      await DBService.db.writeTxn(() async {
        await DBService.db.authors.put(author);
      });

      final book =
          Book()
            ..title = "Aku Gesang"
            ..story = "Aku hanya mahasiswa"
            ..imageURL = ""
            ..authorId = author.id;

      await DBService.db.writeTxn(() async {
        await DBService.db.books.put(book);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "StoryBase",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.yellow,
      ),
      body: SafeArea(child: SizedBox.expand(child: _buildUI())),
      floatingActionButton: FloatingActionButton(
        onPressed: _addOrEditBook,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildUI() {
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];

        return ListTile(
          onTap: () => BookPage(),

          // leading:
          // book.imageURL != null &&,
          title: Row(
            children: [
              CircleAvatar(backgroundImage: NetworkImage(book.imageURL)),
              SizedBox(width: 10),
              Text(book.title),
            ],
          ),
          trailing: Wrap(
            spacing: 12,
            children: [
              IconButton(
                onPressed: () => _addOrEditBook(book: book),
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () async {
                  await DBService.db.writeTxn(() async {
                    await DBService.db.books.delete(book.id);
                  });
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addOrEditBook({Book? book}) async {
    final isEdit = book != null;
    final titleController = TextEditingController(text: book?.title ?? '');
    final storyController = TextEditingController(text: book?.story ?? '');
    final imageURLController = TextEditingController(
      text: book?.imageURL ?? '',
    );

    final authors = await DBService.db.authors.where().findAll();

    if (authors.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add an author first.")),
      );
      return;
    }

    int selectedAuthorId = book?.authorId ?? authors.first.id;

    final result = await showDialog<Book?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEdit ? "Edit Book" : "Add Book"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Book Title"),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: storyController,
                decoration: const InputDecoration(labelText: "Story"),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: imageURLController,
                decoration: const InputDecoration(labelText: "Image URL"),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: selectedAuthorId,
                decoration: const InputDecoration(labelText: "Author"),
                items:
                    authors.map((author) {
                      return DropdownMenuItem(
                        value: author.id,
                        child: Text(author.name),
                      );
                    }).toList(),
                onChanged: (value) {
                  if (value != null) selectedAuthorId = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.trim().isNotEmpty) {
                  final newBook =
                      isEdit
                            ? book.copyWith(
                              title: titleController.text.trim(),
                              story: storyController.text.trim(),
                              imageURL: imageURLController.text.trim(),
                              authorId: selectedAuthorId,
                              id: book.id,
                            )
                            : Book()
                        ..title = titleController.text.trim()
                        ..story = storyController.text.trim()
                        ..imageURL = imageURLController.text.trim()
                        ..authorId = selectedAuthorId;
                  Navigator.of(context).pop(newBook);
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );

    if (result != null) {
      await DBService.db.writeTxn(() async {
        await DBService.db.books.put(result);
      });
    }
  }
}
