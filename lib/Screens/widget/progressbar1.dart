import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class DurationState {
  final Duration progress;
  final Duration buffered;
  final Duration total;
  DurationState({
    required this.progress,
    required this.buffered,
    required this.total,
  });
}

Stream<DurationState> durationStateStream(AudioPlayer player) {
  return Rx.combineLatest3<Duration, Duration, Duration?, DurationState>(
    player.positionStream,
    player.bufferedPositionStream,
    player.durationStream,
    (position, buffered, total) => DurationState(
      progress: position,
      buffered: buffered,
      total: total ?? Duration.zero,
    ),
  );
}

String formatTime(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  if (hours > 0) {
    return "${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}";
  }
  return "${twoDigits(minutes)}:${twoDigits(seconds)}";
}

class ProgressBarr extends StatelessWidget {
  final AudioPlayer player;
  const ProgressBarr({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DurationState>(
      stream: durationStateStream(player),
      builder: (context, snapshot) {
        final state = snapshot.data;

        final total = state?.total ?? Duration.zero;

        final progress = state == null
            ? Duration.zero
            : state.progress > total
            ? total
            : state.progress;

        final buffered = state == null
            ? Duration.zero
            : state.buffered > total
            ? total
            : state.buffered;

        return Column(
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(formatTime(progress), style: const TextStyle(fontSize: 12)),
            //     Text(formatTime(total), style: const TextStyle(fontSize: 12)),
            //   ],
            // ),
            ProgressBar(
              progress: progress,
              buffered: buffered,
              total: total,
              barHeight: 3,
              thumbRadius: 7,
              thumbGlowRadius: 10,
              thumbColor: const Color.fromARGB(255, 44, 44, 72),
              thumbGlowColor: const Color.fromRGBO(224, 237, 226, 1),
              bufferedBarColor: const Color.fromARGB(255, 153, 153, 153),
              progressBarColor: const Color.fromARGB(255, 99, 99, 99),
              timeLabelLocation: TimeLabelLocation.below,
              timeLabelTextStyle: TextStyle(
                color: const Color.fromARGB(255, 176, 176, 176),
                fontSize: 14,
              ),
              onSeek: player.seek,
            ),
          ],
        );
      },
    );
  }
}
