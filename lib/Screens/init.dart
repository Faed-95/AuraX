import 'package:aura_x/Screens/musicpage.dart';
import 'package:aura_x/Screens/widget/maintile.dart';
import 'package:aura_x/controller/audio_controller.dart';
import 'package:aura_x/controller/song.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

List<SongModel> songs = [];
List<SongModel> allSongs = [];

class InitialPage extends StatefulWidget {
  final Function(SongModel) onMusicOpen;
  const InitialPage({super.key, required this.onMusicOpen});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSongs();
    textController.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Future<void> loadSongs() async {
    final result = await SongFunctions().fetchSongs();
    setState(() {
      songs = result;
      allSongs = result;
    });
  }

  void onSearchChanged() {
    final query = textController.text.toLowerCase();
    setState(() {
      songs = allSongs.where((song) {
        final title = song.title.toLowerCase();
        final artist = (song.artist ?? "").toLowerCase();
        return title.contains(query) || artist.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextFormField(
            controller: textController,
            decoration: InputDecoration(
              hintText: "Search songs",
              prefixIcon: const Icon(Icons.search, color: Colors.black54),
              suffixIcon: textController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close, color: Colors.black54),
                      onPressed: () {
                        textController.clear();
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
          child: songs.isEmpty
              ? const Center(
                  child: Text(
                    "No Songs Found",
                    style: TextStyle(color: Colors.black54),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 90),
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs[index];

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

                          playSongs(songs: songs, startIndex: index);
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
