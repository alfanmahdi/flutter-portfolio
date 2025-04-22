import 'dart:async';

import 'package:flutter/material.dart';
import 'package:midterm_exam/models/author.dart';
import 'package:midterm_exam/services/db_service.dart';

class ArtistsPage extends StatefulWidget {
  const ArtistsPage({super.key});

  @override
  State<ArtistsPage> createState() => _ArtistsPageState();
}

class _ArtistsPageState extends State<ArtistsPage> {
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
                () => _addOrEditAuthors(authors: author), // Edit saat tap nama
            child: Text(author.name),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              await DBService.db.writeTxn(() async {
                await DBService.db.authors.delete(author.id);
              });
            },
          ),
        );
      },
    );
  }

  void _addOrEditAuthors({Author? author}) async {
    final isEdit = author != null;
    final nameController = TextEditingController(text: author?.name ?? '');

    final result = await showDialog<Artist?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEdit ? 'Edit Artist' : 'Add Artist'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Artist Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  final newArtist =
                      isEdit
                          ? artist.copyWith(
                            name: nameController.text.trim(),
                            id: artist.id,
                          )
                          : Artist(name: nameController.text.trim());

                  Navigator.pop(context, newArtist);
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
        await DBService.db.artists.put(result);
      });
    }
  }
}
