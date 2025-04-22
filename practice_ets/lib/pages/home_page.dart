import 'dart:io';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:practice_ets/models/artist.dart';
import 'package:practice_ets/models/song.dart';
import 'package:practice_ets/pages/artists_page.dart';
import 'dart:async';
import 'package:practice_ets/services/db_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Song> songs = [];
  final coverPath = 'assets/images/song_cover.png';

  StreamSubscription? songsStream;
  @override
  void initState() {
    super.initState();
    songsStream = DBService.db.songs
        .buildQuery<Song>()
        .watch(fireImmediately: true)
        .listen((data) {
          setState(() {
            songs = data;
          });
        });
    initDummyData();
  }

  @override
  void dispose() {
    songsStream?.cancel();
    super.dispose();
  }

  Future<Artist?> getArtistFromSong(Song song) async {
    return await DBService.db.artists.get(song.artistId);
  }

  Future<void> initDummyData() async {
    final hasArtist = await DBService.db.artists.count() > 0;
    if (!hasArtist) {
      final artist = Artist(name: "Arctic Monkeys");
      await DBService.db.writeTxn(() async {
        await DBService.db.artists.put(artist);
      });

      final song =
          Song()
            ..title = "Do I Wanna Know"
            ..artistId = artist.id
            ..pathImage = coverPath;

      await DBService.db.writeTxn(() async {
        await DBService.db.songs.put(song);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Music App"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ArtistsPage()),
              );
            },
            child: const Text("Artist", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: SafeArea(child: SizedBox.expand(child: _buildUI())),
      floatingActionButton: FloatingActionButton(
        onPressed: _addOrEditSong,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildUI() {
    return ListView.builder(
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        return FutureBuilder<Artist?>(
          future: getArtistFromSong(song),
          builder: (context, snapshot) {
            final artistName = snapshot.data?.name ?? "Unknown artist";

            return ListTile(
              onTap: () => _addOrEditSong(song: song),
              leading:
                  song.pathImage != null && File(song.pathImage!).existsSync()
                      ? Image.file(
                        File(song.pathImage!),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                      : Image.asset(
                        song.pathImage ?? coverPath,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
              title: Text(song.title),
              subtitle: Text(artistName),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  await DBService.db.writeTxn(() async {
                    await DBService.db.songs.delete(song.id);
                  });
                },
              ),
            );
          },
        );
      },
    );
  }

  void _addOrEditSong({Song? song}) async {
    final isEdit = song != null;
    final titleController = TextEditingController(text: song?.title ?? '');

    final artists = await DBService.db.artists.where().findAll();

    if (artists.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add an artist first.")),
      );
      return;
    }

    int selectedArtistId = song?.artistId ?? artists.first.id;

    final result = await showDialog<Song?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEdit ? "Edit Song" : "Add Song"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Song Title"),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: selectedArtistId,
                decoration: const InputDecoration(labelText: "Artist"),
                items:
                    artists.map((artist) {
                      return DropdownMenuItem(
                        value: artist.id,
                        child: Text(artist.name),
                      );
                    }).toList(),
                onChanged: (value) {
                  if (value != null) selectedArtistId = value;
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
                  final newSong =
                      isEdit
                            ? song.copyWith(
                              title: titleController.text.trim(),
                              artistId: selectedArtistId,
                              pathImage: coverPath,
                              id: song.id,
                            )
                            : Song()
                        ..title = titleController.text.trim()
                        ..artistId = selectedArtistId
                        ..pathImage = coverPath;
                  Navigator.of(context).pop(newSong);
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
        await DBService.db.songs.put(result);
      });
    }
  }
}
