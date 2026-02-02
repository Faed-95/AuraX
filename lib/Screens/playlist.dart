import 'package:aura_x/Screens/detail_list.dart';
import 'package:aura_x/Screens/widget/playlisttile.dart';
import 'package:aura_x/models/playlist_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PlaylistPage extends StatelessWidget {
  const PlaylistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<PlaylistModel>('playbox');

    return ValueListenableBuilder<Box<PlaylistModel>>(
      valueListenable: box.listenable(),
      builder: (context, box, _) {
        final playlists = box.values.toList();

        // if (playlists.isEmpty) {
        //   return const Center(
        //     child: Text(
        //       "No playlists yet",
        //       style: TextStyle(color: Colors.white70),
        //     ),
        //   );
        // }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          itemCount: playlists.length,
          separatorBuilder: (_, _) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final playlist = playlists[index];

            return Slidable(
              key: ValueKey(playlist.key),

              endActionPane: playlist.isDefault
                  ? null
                  : ActionPane(
                      motion: const StretchMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (_) {
                            box.delete(playlist.key);
                          },
                          icon: Icons.delete_outline,
                          backgroundColor: Colors.red.shade600,
                          foregroundColor: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ],
                    ),

              child: PlaylistTile(
                playlist: playlist,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailList(playlist: playlist),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
