import 'package:aura_x/Screens/musicpage.dart';
import 'package:aura_x/Screens/widget/maintile.dart';
import 'package:aura_x/controller/audio_controller.dart';
import 'package:aura_x/controller/color_palette.dart';
import 'package:aura_x/models/playlist_model.dart';
import 'package:aura_x/Screens/widget/songtile.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart' hide PlaylistModel;

class DetailList extends StatefulWidget {
  final PlaylistModel playlist;

  const DetailList({super.key, required this.playlist});

  @override
  State<DetailList> createState() => _DetailListState();
}

class _DetailListState extends State<DetailList> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = audioPlayer;

  List<SongModel> playlistSongs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlaylistSongs();
  }

  Future<void> _loadPlaylistSongs() async {
    final allSongs = await _audioQuery.querySongs(
      uriType: UriType.EXTERNAL,
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
    );

    playlistSongs = allSongs
        .where((song) => widget.playlist.songID.contains(song.id))
        .toList();

    setState(() => isLoading = false);
  }

 Future<void> _playSong(int index) async {
    await _audioPlayer.stop();
    currentQueue = playlistSongs;

    final source = ConcatenatingAudioSource(
      children: playlistSongs
          .map((song) => AudioSource.uri(Uri.parse(song.data)))
          .toList(),
    );

    await _audioPlayer.setAudioSource(source, initialIndex: index);
    if (isShuffleEnabled.value) {
      await audioPlayer.shuffle();
      await audioPlayer.setShuffleModeEnabled(true);
    }

    await _audioPlayer.play();
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.playlist.title)),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : playlistSongs.isEmpty
                ? const Center(child: Text("No songs in this playlist"))
                : ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: playlistSongs.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final song = playlistSongs[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const Musicpage(),
                            ),
                          );

                          _playSong(index);
                        },

                        child: MainTile(
                          title: song.title,
                          subtitle: song.artist ?? "Unknown Artist",
                          leading: QueryArtworkWidget(
                            id: song.id,
                            type: ArtworkType.AUDIO,
                            artworkWidth: 50,
                            artworkHeight: 50,
                            nullArtworkWidget: const Icon(Icons.music_note),
                          ),
                        ),
                      );
                    },
                  ),
          ),

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
    );
  }
}
