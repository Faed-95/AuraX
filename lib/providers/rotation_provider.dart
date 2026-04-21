import 'dart:async';

import 'package:flutter/material.dart';

class RotationProvider extends ChangeNotifier{
double angle =0;
bool isPlaying = false;

Timer? timer;

void start(){
  if(timer !=null) return;

  timer = Timer.periodic(Duration(milliseconds: 16), (_){
    if(isPlaying){
      angle += 0.0033;
      notifyListeners();
    }
  });
}

void updatePlaying(bool playing){
isPlaying = playing;
if(isPlaying){
  start();
}
}

void stop(){
  timer?.cancel();
  timer =null;
}

@override
void dispose(){
  stop();
  super.dispose();
}

}