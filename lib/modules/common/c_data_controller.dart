import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_super_scaffold/flutter_super_scaffold.dart';
import 'package:free_one_piece_manga/modules/common/m_downloaded_chapter_model.dart';
import 'package:free_one_piece_manga/services/sp_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataController extends GetxController{
  String apiToken = '';
  List<ChapterModel> downloadedChapters = [];
  String recentChapterReadLink = '-';

  Future<void> getAllData() async{
    await getDownloadChapters();
    await getLastReadChapter();
    update();
  }


  Future<void> getDownloadChapters() async{
    downloadedChapters.clear();
    try{
      SharedPreferences sp = await SharedPreferences.getInstance();
      List<dynamic> rawResult = sp.getStringList(SpService.downloadKey)??[];
      downloadedChapters.addAll(
          rawResult.map((e) {
            Map<String,dynamic> data = jsonDecode(e);
            return ChapterModel.fromMap(data: data);
          })
      );
    }
    catch(e){
      superPrint(e);
      null;
    }
  }

  Future<void> getLastReadChapter() async{
    recentChapterReadLink = '';
    try{
      SharedPreferences sp = await SharedPreferences.getInstance();
      recentChapterReadLink = sp.getString(SpService.recentChapterLinkKey)??'';
      superPrint(recentChapterReadLink);
    }
    catch(e){
      superPrint(e);
      null;
    }
  }

  bool xChapterIsDownloaded({required String link}){
    bool xDownloaded = false;
    for (var value in downloadedChapters) {
      if(value.link == link){
        xDownloaded = true;
      }
    }
    return xDownloaded;
  }


}