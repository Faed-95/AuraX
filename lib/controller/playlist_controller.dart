import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart' hide PlaylistModel;
import 'package:aura_x/models/playlist_model.dart';

void showAddToPlaylistSheet(BuildContext context, SongModel song) {
  

  showModalBottomSheet(
  context: context,
  builder: (_) {
    final box = Hive.box<PlaylistModel>('playbox');

    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (context, Box<PlaylistModel> box, _) {
        final playlists = box.values.toList();

        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: ListView.separated(
              itemCount: playlists.length, 
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final playlist = playlists[index];
                final alreadyAdded =
                    playlist.songID.contains(song.id);

                return ListTile(
                  title: Text(playlist.title),
                  trailing: Icon(
                    alreadyAdded
                        ? Icons.check_circle
                        : Icons.add_circle_outline,
                  ),
                  onTap: () {
                    toggleSongInPlaylist(playlist, song.id);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  },
);

}

void toggleSongInPlaylist(PlaylistModel playlist, int songId) {
  if (playlist.songID.contains(songId)) {
    playlist.songID.remove(songId);
  } else {
    playlist.songID.add(songId);
  }

  playlist.save();
}

void addToLikedSongs(SongModel song) {
  final box = Hive.box<PlaylistModel>('playbox');

  final likedPlaylist =
      box.values.firstWhere((p) => p.isDefault);

  if (!likedPlaylist.songID.contains(song.id)) {
    likedPlaylist.songID.add(song.id);
    likedPlaylist.save();
  }
}

