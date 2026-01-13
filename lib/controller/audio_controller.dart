import 'dart:typed_data';


import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:palette_generator/palette_generator.dart';

final audioPlayer = AudioPlayer();
final ValueNotifier<bool> isShuffleEnabled = ValueNotifier(false);
final ValueNotifier<LoopMode> loopModeNotifier = ValueNotifier(LoopMode.off);

ValueNotifier<Color> dominantColorNotifier = ValueNotifier<Color>(Colors.black);
List<SongModel> currentQueue = [];

final OnAudioQuery _audioQuery = OnAudioQuery();

Future<void> updateDominantColor(SongModel song) async {
  try {
    Uint8List? artwork = await _audioQuery.queryArtwork(
      song.id,
      ArtworkType.AUDIO,
    );

    if (artwork == null) {
      dominantColorNotifier.value = Colors.black;
      return;
    }

    final imageProvider = MemoryImage(artwork);

    final palette = await PaletteGenerator.fromImageProvider(
      imageProvider,
      maximumColorCount: 12,
    );

    dominantColorNotifier.value = palette.dominantColor?.color ?? Colors.black;
  } catch (e) {
    dominantColorNotifier.value = Colors.black;
  }
}

Future<void> setLoopMode(LoopMode mode) async {
  loopModeNotifier.value = mode;
  await audioPlayer.setLoopMode(mode);
}

Future<void> enableShuffle(bool enable) async {
  if (enable) {
    await audioPlayer.shuffle();
  }
  await audioPlayer.setShuffleModeEnabled(enable);
}

Future<void> loadPlaylist(List<SongModel> songs, int startIndex) async {
  final playlist = songs.map((song) {
    return AudioSource.uri(Uri.parse(song.data));
  }).toList();

  await audioPlayer.setAudioSource(
    ConcatenatingAudioSource(children: playlist),
    initialIndex: startIndex,
  );
}