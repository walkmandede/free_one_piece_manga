import 'package:flutter/services.dart';

void vibrateNow(){
  VibrateService.medium();
}

class VibrateService{

  static void vibrate(){
    try{
      HapticFeedback.vibrate();
    }catch(e){
      null;
    }
  }

  static void heavy(){
    try{
      HapticFeedback.heavyImpact();
    }catch(e){
      null;
    }
  }

  static void selection(){
    try{
      HapticFeedback.selectionClick();
    }catch(e){
      null;
    }
  }

  static void medium(){
    try{
      HapticFeedback.mediumImpact();
    }catch(e){
      null;
    }
  }



}