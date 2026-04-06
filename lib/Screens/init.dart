import 'package:aura_x/Screens/musicpage.dart';
import 'package:aura_x/Screens/widget/maintile.dart';
import 'package:aura_x/controller/audio_controller.dart';
import 'package:aura_x/controller/song.dart';
import 'package:aura_x/providers/init_provider.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class InitialPage extends StatelessWidget {
  final Function(SongModel) onMusicOpen;
  const InitialPage({super.key, required this.onMusicOpen});

  @override
  Widget build(BuildContext context) {
    final initProvider = context.watch<InitProvider>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextFormField(
            controller: initProvider.textCtrl,
            decoration: InputDecoration(
              hintText: "Search songs",
              prefixIcon: const Icon(Icons.search, color: Colors.black54),
              suffixIcon: initProvider.textCtrl.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close, color: Colors.black54),
                      onPressed: () {
                        initProvider.textCtrl.clear();
                        FocusScope.of(context).unfocus();
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.grey.shade200,
              hintStyle: const TextStyle(color: Colors.black45),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(color: Colors.black87),
          ),
        ),

        Expanded(
          child: initProvider.songs.isEmpty
              ? const Center(
                  child: Text(
                    "No Songs Found",
                    style: TextStyle(color: Colors.black54),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 90),
                  itemCount: initProvider.songs.length,
                  itemBuilder: (context, index) {
                    final song = initProvider.songs[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      child: MainTile(
                        title: song.title,
                        subtitle: song.artist ?? "Unknown Artist",

                        leading: QueryArtworkWidget(
                          id: song.id,
                          type: ArtworkType.AUDIO,
                          artworkWidth: 50,
                          artworkHeight: 50,
                          artworkBorder: BorderRadius.circular(10),
                          nullArtworkWidget: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.music_note,
                              color: Colors.black54,
                            ),
                          ),
                        ),

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const Musicpage(),
                            ),
                          );
                          playSongs(songs: initProvider.songs, startIndex: index);
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
