import 'dart:async';

import 'package:flutter/material.dart';
import 'package:midterm_exam/models/author.dart';
import 'package:midterm_exam/services/db_service.dart';

class AuthorsPage extends StatefulWidget {
  const AuthorsPage({super.key});

  @override
  State<AuthorsPage> createState() => _AuthorsPageState();
}

class _AuthorsPageState extends State<AuthorsPage> {
  List<Author> authors = [];
  StreamSubscription? authorsStream;

  @override
  void initState() {
    super.initState();
    authorsStream = DBService.db.authors
        .buildQuery<Author>()
        .watch(fireImmediately: true)
        .listen((data) {
          setState(() {
            authors = data;
          });
        });
  }

  @override
  void dispose() {
    authorsStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Authors')),
      body: SafeArea(child: SizedBox.expand(child: _buildUI())),
      floatingActionButton: FloatingActionButton(
        onPressed: _addOrEditAuthors,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildUI() {
    if (authors.isEmpty) {
      return const Center(child: Text("There are no authors yet."));
    }

    return ListView.builder(
      itemCount: authors.length,
      itemBuilder: (context, index) {
        final author = authors[index];
        return ListTile(
          leading: const Icon(Icons.person),
          title: GestureDetector(
            onTap:
                () => _addOrEditAuthors(author: author), // Edit saat tap nama
            child: Text(author.name),
          ),
          trailing: Wrap(
            spacing: 12,
            children: [
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  await DBService.db.writeTxn(() async {
                    await DBService.db.authors.delete(author.id);
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _addOrEditAuthors({Author? author}) async {
    final isEdit = author != null;
    final nameController = TextEditingController(text: author?.name ?? '');
    final hometownController = TextEditingController(
      text: author?.hometown ?? '',
    );

    final result = await showDialog<Author?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEdit ? 'Edit Author' : 'Add Author'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Author Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  final newAuthor =
                      isEdit
                          ? author.copyWith(
                            name: nameController.text.trim(),
                            hometown: hometownController.text.trim(),
                            id: author.id,
                          )
                          : Author(
                            name: nameController.text.trim(),
                            hometown: hometownController.text.trim(),
                          );

                  Navigator.pop(context, newAuthor);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      await DBService.db.writeTxn(() async {
        await DBService.db.authors.put(result);
      });
    }
  }
}
