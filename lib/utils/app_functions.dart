import 'dart:async';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppFunctions {

  static String convertLinkToTitle({required String link}){
    String result = link;
    try{
      result = 'Chapter ${link.split('chapter').last.replaceAll('/', '').replaceAll('-', '-')}';
      result = result.split('-')[1];
    }
    catch(e){
      null;
    }
    return result;
  }

  Future<bool> preCacheImage(String imageUrl) async {
    bool xSuccess = true;
    try{
      await precacheImage(
        CachedNetworkImageProvider(imageUrl),
        Get.context!,
        onError: (exception, stackTrace) {
          xSuccess = false;
        },
      );
    }
    catch(e){
      xSuccess = false;
    }
    return xSuccess;
  }

}