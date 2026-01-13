import 'package:aura_x/Screens/home.dart';
import 'package:aura_x/models/playlist_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';


Future<void> createDefaultPlaylist() async {
  final box = Hive.box<PlaylistModel>('playbox');

  final exists = box.values.any(
    (playlist) => playlist.title == 'Liked Songs',
  );

  if (!exists) {
    box.add(
      PlaylistModel(
        title: 'Liked Songs',
        songID: [],
        isDefault: true,
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(PlaylistModelAdapter());
  await Hive.openBox<PlaylistModel>('playbox');
  await createDefaultPlaylist();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: ThemeData(scaffoldBackgroundColor: Colors.grey),
    );
  }
}






















































































 // if (Mp.show)
          //   Positioned(
          //     child: MusicTile(
          //       // color: Colors.blue,
          //       title: Mp.title!,
          //       subtitle: Mp.subtitle!,
          //       cover: Mp.cover!,
          //     ),
          //   ),
