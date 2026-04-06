import 'package:aura_x/models/playlist_model.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart' hide PlaylistModel;

class DetailProvider extends ChangeNotifier{
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> playlistSongs = [];
  bool isLoading = false;
  


   Future<void> loadPlaylistSongs(PlaylistModel playlist) async {
    if(isLoading)false;

    isLoading = true;
    notifyListeners();

    final allSongs = await _audioQuery.querySongs(
      uriType: UriType.EXTERNAL,
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
    );

    playlistSongs = allSongs
        .where((song) => playlist.songID.contains(song.id))
        .toList();

    isLoading = false;
    notifyListeners();

  } 

}