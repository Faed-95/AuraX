import 'package:aura_x/models/playlist_model.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PlaylistTile extends StatelessWidget {
  final VoidCallback onTap;
  final PlaylistModel playlist;

  const PlaylistTile({super.key, required this.onTap, required this.playlist});

  @override
  Widget build(BuildContext context) {
    final bool isLiked = playlist.isDefault;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),

         
          gradient: LinearGradient(
            colors: isLiked
                ? [Colors.green.withAlpha(220), Colors.green.shade900]
                : [Colors.grey.shade900, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(140),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
           
            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: isLiked
                    ? Colors.green.withAlpha(180)
                    : Colors.grey.shade800,
              ),
              child: Icon(
                isLiked ? Icons.favorite : Icons.queue_music_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),

            const SizedBox(width: 14),

            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    playlist.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${playlist.songID.length} songs",
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),

          
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.white70,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}
