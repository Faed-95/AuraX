import 'package:aura_x/models/playlist_model.dart';
import 'package:flutter/material.dart';

class PlaylistTile extends StatelessWidget {
  final VoidCallback onTap;
  final PlaylistModel playlist;

  const PlaylistTile({
    super.key,
    required this.onTap,
    required this.playlist,
  });

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
                ? const [
                    Color.fromARGB(255, 225, 245, 234), 
                    Color.fromARGB(255, 200, 230, 215),
                  ]
                : const [
                    Color.fromARGB(255, 245, 245, 245),
                    Color.fromARGB(255, 235, 235, 235),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),

          
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(20, 0, 0, 0),
              blurRadius: 12,
              offset: Offset(0, 6),
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
                    ? const Color.fromARGB(255, 180, 220, 200)
                    : const Color.fromARGB(255, 220, 220, 220),
              ),
              child: Icon(
                isLiked ? Icons.favorite : Icons.queue_music_rounded,
                color: isLiked ? Colors.green.shade700 : Colors.black54,
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
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${playlist.songID.length} songs",
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.black45,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}
