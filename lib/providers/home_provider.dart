import 'package:aura_x/controller/audio_controller.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomePageProvider extends ChangeNotifier{ 
  int selectedIndex = 0;
  SongModel? currentSong;

   final textCtrl = TextEditingController();


  void changeIndex (int index){
    selectedIndex = index;
    notifyListeners();
  }

  void setCurrentSong(SongModel song){
    currentSong = song;
    notifyListeners();
  }


Future<void> playSong(List<SongModel> songs, SongModel song) async {
    int index = songs.indexWhere((s) => s.id == song.id);
    if (index == -1) index = 0;

    setCurrentSong(song);

    await loadPlaylist(songs, index);
    await audioPlayer.play();
  }

  
}