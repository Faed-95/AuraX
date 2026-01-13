
import 'package:aura_x/models/playlist_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveFunctions {
  static Box<PlaylistModel> get xbox =>
      Hive.box<PlaylistModel>('playbox');

  
  static void add(PlaylistModel value) {
    xbox.add(value);
  }


}
