import 'package:aura_x/Screens/init.dart';
import 'package:aura_x/Screens/musicpage.dart';
import 'package:aura_x/Screens/playlist.dart';
import 'package:aura_x/controller/audio_controller.dart';
import 'package:aura_x/controller/color_palette.dart';
import 'package:aura_x/controller/hive__functions.dart';
import 'package:aura_x/models/playlist_model.dart';
import 'package:aura_x/Screens/widget/songtile.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart' hide PlaylistModel;

class HomePage extends StatefulWidget {
  final PlaylistModel? playlist;
  const HomePage({super.key, this.playlist});

  @override
  State<HomePage> createState() => HomePageState();
}

final formKey = GlobalKey<FormState>();

class HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  SongModel? currentSong;

  Future<void> openMusicPage(SongModel song) async {
    final startIndex = songs.indexWhere((s) => s.id == song.id);

    setState(() {
      currentSong = song;
    });

    await loadPlaylist(songs, startIndex);
    await audioPlayer.play();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const Musicpage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textCtrl = TextEditingController();
    void onSave() {
      if (widget.playlist == null) {
        final playlist = PlaylistModel(title: textCtrl.text, songID: []);
        HiveFunctions.add(playlist);
      }
      Navigator.pop(context);
    }

    void addPlayList() {
      showDialog(
        context: context,
        builder: (ctx) {
          return Form(
            key: formKey,
            child: AlertDialog(
              title: Text("Create Playlist"),
              content: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name for your platylist';
                  }
                  return null;
                },
                controller: textCtrl,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      onSave();
                    }
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          );
        },
      );
    }

    final List<Widget> pages = [
      InitialPage(onMusicOpen: openMusicPage),
      PlaylistPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        actions: selectedIndex == 1
            ? [
                IconButton(
                  onPressed: () {
                    addPlayList();
                  },
                  icon: Icon(Icons.add),
                  color: Colors.white,
                ),
              ]
            : [],
        animateColor: false,
        backgroundColor: const Color.fromARGB(255, 71, 71, 71),
      ),
      body: Stack(
        children: [
          pages[selectedIndex],

          StreamBuilder<int?>(
            stream: audioPlayer.currentIndexStream,
            builder: (context, snapshot) {
              final index = snapshot.data;

              if (index == null ||
                  currentQueue.isEmpty ||
                  index >= currentQueue.length) {
                return const SizedBox();
              }

              final song = currentQueue[index];

              return Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: MusicTile(
                  title: song.title,
                  subtitle: song.artist ?? "Unknown",
                  backgroundColor: const Color.fromARGB(255, 57, 57, 57),

                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: QueryArtworkWidget(
                      id: song.id,
                      type: ArtworkType.AUDIO,
                      artworkWidth: 45,
                      artworkHeight: 45,
                      nullArtworkWidget: Container(
                        width: 45,
                        height: 45,
                        color: Colors.deepPurple,
                        child: const Icon(
                          Icons.music_note,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  trailing: StreamBuilder<PlayerState>(
                    stream: audioPlayer.playerStateStream,
                    builder: (context, snapshot) {
                      final playing = snapshot.data?.playing ?? false;

                      return IconButton(
                        icon: Icon(
                          playing ? Icons.pause : Icons.play_arrow,
                          color: accent,
                          size: 30,
                        ),
                        onPressed: () {
                          playing ? audioPlayer.pause() : audioPlayer.play();
                        },
                      );
                    },
                  ),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const Musicpage()),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) => setState(() {
          selectedIndex = index;
        }),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.queue_music_rounded),
            label: '',
          ),
        ],
      ),
    );
  }
}
