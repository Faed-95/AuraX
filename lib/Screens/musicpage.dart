import 'package:aura_x/Screens/widget/musicbutton.dart';
import 'package:aura_x/Screens/widget/progressbar1.dart';
import 'package:aura_x/controller/audio_controller.dart';
import 'package:aura_x/controller/playlist_controller.dart';
import 'package:aura_x/models/playlist_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart' hide PlaylistModel;

class Musicpage extends StatelessWidget {
  const Musicpage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: dominantColorNotifier,
      builder: (context, bgColor, _) {
        return Scaffold(
          backgroundColor: Colors.black,

          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.keyboard_arrow_down_sharp,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          body: StreamBuilder<int?>(
            stream: audioPlayer.currentIndexStream,
            builder: (context, snapshot) {
              final index = snapshot.data;

              if (index == null ||
                  currentQueue.isEmpty ||
                  index >= currentQueue.length) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              final song = currentQueue[index];

              updateDominantColor(song);

              final title = song.title.length > 40
                  ? '${song.title.substring(0, 40)}...'
                  : song.title;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [bgColor.withAlpha(217), Colors.black],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SingleChildScrollView(
                  // physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),

                      Center(
                        child: Container(
                          width: 320,
                          height: 320,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: bgColor.withAlpha(115),
                                blurRadius: 35,
                                offset: const Offset(0, 18),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: QueryArtworkWidget(
                              id: song.id,
                              type: ArtworkType.AUDIO,
                              artworkFit: BoxFit.cover,
                              nullArtworkWidget: Container(
                                color: Colors.black54,
                                child: const Icon(
                                  Icons.music_note,
                                  size: 90,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        song.artist ?? "Unknown Artist",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 14),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: ProgressBarr(player: audioPlayer),
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: ValueListenableBuilder(
                            valueListenable: Hive.box<PlaylistModel>(
                              'playbox',
                            ).listenable(),
                            builder: (context, Box<PlaylistModel> box, _) {
                              final likedPlaylist = box.values.firstWhere(
                                (p) => p.isDefault,
                              );
                              final isLiked = likedPlaylist.songID.contains(
                                song.id,
                              );

                              return IconButton(
                                icon: Icon(
                                  isLiked
                                      ? Icons.check_circle
                                      : Icons.add_circle_outline,
                                  color: isLiked ? Colors.green : Colors.white,
                                  size: 26,
                                ),
                                onPressed: () {
                                  if (!isLiked) {
                                    likedPlaylist.songID.add(song.id);
                                    likedPlaylist.save();
                                  }
                                },
                                onLongPress: () {
                                  showAddToPlaylistSheet(context, song);
                                },
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      StreamBuilder<PlayerState>(
                        stream: audioPlayer.playerStateStream,
                        builder: (context, snapshot) {
                          final playing = snapshot.data?.playing ?? false;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ValueListenableBuilder<LoopMode>(
                                valueListenable: loopModeNotifier,
                                builder: (context, mode, _) {
                                  return MusicButton(
                                    onPressed: () async {
                                      if (mode == LoopMode.off) {
                                        await setLoopMode(LoopMode.all);
                                      } else if (mode == LoopMode.all) {
                                        await setLoopMode(LoopMode.one);
                                      } else {
                                        await setLoopMode(LoopMode.off);
                                      }
                                    },
                                    icon: Icon(
                                      mode == LoopMode.one
                                          ? Icons.repeat_one
                                          : Icons.repeat,
                                      size: 22,
                                      color: mode == LoopMode.off
                                          ? Colors.white
                                          : Colors.green,
                                    ),
                                  );
                                },
                              ),

                              MusicButton(
                                onPressed: audioPlayer.seekToPrevious,
                                icon: const Icon(
                                  Icons.skip_previous_rounded,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              ),

                              MusicButton(
                                onPressed: () {
                                  playing
                                      ? audioPlayer.pause()
                                      : audioPlayer.play();
                                },
                                icon: Icon(
                                  playing ? Icons.pause : Icons.play_arrow,
                                  size: 54,
                                  color: Colors.white,
                                ),
                              ),

                              MusicButton(
                                onPressed: audioPlayer.seekToNext,
                                icon: const Icon(
                                  Icons.skip_next_rounded,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              ),

                              ValueListenableBuilder<bool>(
                                valueListenable: isShuffleEnabled,
                                builder: (context, enabled, _) {
                                  return MusicButton(
                                    onPressed: () async {
                                      final newValue = !enabled;
                                      isShuffleEnabled.value = newValue;
                                      await enableShuffle(newValue);
                                    },
                                    icon: Icon(
                                      Icons.shuffle,
                                      size: 22,
                                      color: enabled
                                          ? Colors.green
                                          : Colors.white,
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
