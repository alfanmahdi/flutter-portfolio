import 'dart:async';

import 'package:flutter/material.dart';
import 'package:practice_ets/models/artist.dart';
import 'package:practice_ets/services/db_service.dart';

class ArtistsPage extends StatefulWidget {
  const ArtistsPage({super.key});

  @override
  State<ArtistsPage> createState() => _ArtistsPageState();
}

class _ArtistsPageState extends State<ArtistsPage> {
  List<Artist> artists = [];
  StreamSubscription? artistsStream;

  @override
  void initState() {
    super.initState();
    artistsStream = DBService.db.artists
        .buildQuery<Artist>()
        .watch(fireImmediately: true)
        .listen((data) {
          setState(() {
            artists = data;
          });
        });
  }

  @override
  void dispose() {
    artistsStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Artists')),
      body: SafeArea(child: SizedBox.expand(child: _buildUI())),
      floatingActionButton: FloatingActionButton(
        onPressed: _addOrEditArtist,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildUI() {
    if (artists.isEmpty) {
      return const Center(child: Text("There are no artists yet."));
    }

    return ListView.builder(
      itemCount: artists.length,
      itemBuilder: (context, index) {
        final artist = artists[index];
        return ListTile(
          leading: const Icon(Icons.person),
          title: GestureDetector(
            onTap: () => _addOrEditArtist(artist: artist), // Edit saat tap nama
            child: Text(artist.name),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              await DBService.db.writeTxn(() async {
                await DBService.db.artists.delete(artist.id);
              });
            },
          ),
        );
      },
    );
  }

  void _addOrEditArtist({Artist? artist}) async {
    final isEdit = artist != null;
    final nameController = TextEditingController(text: artist?.name ?? '');

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
