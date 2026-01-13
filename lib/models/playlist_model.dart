import 'package:hive_flutter/hive_flutter.dart';
part 'playlist_model.g.dart';

@HiveType(typeId: 0)
class PlaylistModel extends HiveObject {

  @HiveField(0)
  String title;

  @HiveField(1)
  List<int> songID;

  @HiveField(2)
  bool isDefault;

  PlaylistModel({
    required this.title,
    List<int>? songID,
    bool? isDefault,
  })  : songID = songID ?? [],
        isDefault = isDefault ?? false;
}
