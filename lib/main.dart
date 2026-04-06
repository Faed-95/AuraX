import 'package:aura_x/Screens/home.dart';
import 'package:aura_x/Screens/onboarding.dart';
import 'package:aura_x/models/playlist_model.dart';
import 'package:aura_x/providers/detaillist_provider.dart';
import 'package:aura_x/providers/home_provider.dart';
import 'package:aura_x/providers/init_provider.dart';
import 'package:aura_x/providers/onboarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> createDefaultPlaylist() async {
  final box = Hive.box<PlaylistModel>('playbox');

  final exists = box.values.any((playlist) => playlist.title == 'Liked Songs');

  if (!exists) {
    box.add(PlaylistModel(title: 'Liked Songs', songID: [], isDefault: true));
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final showOnBoarding = !(prefs.getBool('onBoardingDone') ?? false);

  await Hive.initFlutter();
  Hive.registerAdapter(PlaylistModelAdapter());
  await Hive.openBox<PlaylistModel>('playbox');
  await createDefaultPlaylist();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.example.audioplayer_app.audio',
    androidNotificationChannelName: 'Audio Playback',
    androidNotificationOngoing: true,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>HomePageProvider()),
        ChangeNotifierProvider(create: (context)=>InitProvider()),
        ChangeNotifierProvider(create: (context)=>DetailProvider()),
        ChangeNotifierProvider(create: (context)=>OnBoardingProvider()),
        
      ],
      child: MyApp(showOnBoarding: showOnBoarding),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool showOnBoarding;
  const MyApp({super.key, required this.showOnBoarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: showOnBoarding ? OnBoarding() : HomePage(),
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 239, 239, 239),
      ),
    );
  }
}
