import 'package:aura_x/controller/song.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class InitProvider extends ChangeNotifier {
  List<SongModel> songs = [];
  List<SongModel> allSongs = [];

  final textCtrl = TextEditingController();

  InitProvider() {
    loadSongs();
    textCtrl.addListener(onSearchChanged);
  }

  Future<void> loadSongs() async {
    final result = await SongFunctions().fetchSongs();
    songs = result;
    allSongs = result;
    notifyListeners();
  }

  void onSearchChanged(){
      final query = textCtrl.text.toLowerCase();
    
      songs = allSongs.where((song) {
        final title = song.title.toLowerCase();
        final artist = (song.artist ?? "").toLowerCase();
        return title.contains(query) || artist.contains(query);
      }).toList();
    notifyListeners();
  }

  void clearSearch(){
    textCtrl.clear();
    songs = allSongs;
    notifyListeners();
  }


  @override
  void dispose(){
    textCtrl.dispose();
    super.dispose();
  }
}
