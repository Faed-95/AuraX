import 'dart:math';
import 'dart:ui';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class SongFunctions {
  // fetch songs

  final OnAudioQuery audioQuery = OnAudioQuery();

  Future<List<SongModel>> fetchSongs() async {
    bool permission = await audioQuery.permissionsStatus();

    if (!permission) {
      permission = await audioQuery.permissionsRequest();
    }
    if (!permission) return [];

    return audioQuery.querySongs(
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
  }

  //
  Future<List<SongModel>> loadSongs() async {
    final result = await fetchSongs();
    return result;
  }

  //
  Color getRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(200),
      random.nextInt(200),
      random.nextInt(200),
    );
  }

  //

  Future<bool> reqPermission() async {
    final PermissionStatus status = await Permission.storage.request();
    return status.isGranted;
  }

  //
}
