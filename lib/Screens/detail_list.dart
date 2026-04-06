import 'package:aura_x/Screens/musicpage.dart';
import 'package:aura_x/Screens/widget/maintile.dart';
import 'package:aura_x/Screens/widget/songtile.dart';
import 'package:aura_x/controller/audio_controller.dart';
import 'package:aura_x/controller/color_palette.dart';
import 'package:aura_x/models/playlist_model.dart';
import 'package:aura_x/providers/detaillist_provider.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart' hide PlaylistModel;
import 'package:provider/provider.dart';

class DetailList extends StatefulWidget {
  final PlaylistModel playlist;

  const DetailList({super.key, required this.playlist});

  @override
  State<DetailList> createState() => _DetailListState();
}

class _DetailListState extends State<DetailList> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<DetailProvider>().loadPlaylistSongs(widget.playlist);
    });
  }

  @override
  Widget build(BuildContext context) {
    final detailProvider = context.watch<DetailProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(widget.playlist.title)),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: detailProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : detailProvider.playlistSongs.isEmpty
                ? const Center(child: Text("No songs in this playlist"))
                : ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: detailProvider.playlistSongs.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final song = detailProvider.playlistSongs[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const Musicpage(),
                            ),
                          );

                          playSongs(
                            songs: detailProvider.playlistSongs,
                            startIndex: index,
                          );
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
                  backgroundColor: const Color.fromARGB(255, 189, 245, 255),

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
