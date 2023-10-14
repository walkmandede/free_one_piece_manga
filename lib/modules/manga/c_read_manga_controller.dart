import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_super_scaffold/flutter_super_scaffold.dart';
import 'package:free_one_piece_manga/modules/common/c_data_controller.dart';
import 'package:free_one_piece_manga/modules/common/m_downloaded_chapter_model.dart';
import 'package:free_one_piece_manga/services/sp_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/vibrate_service.dart';
import 'c_manga_list_controller.dart';

class ReadMangaController extends GetxController{

  bool xLoading = true;
  PageController pageController = PageController();
  DataController dataController = Get.find();
  bool xFullScreen = true;

  Future<void> initLoad() async{

  }

  Future<void> setAsRecentRead({required String link}) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(SpService.recentChapterLinkKey, link);
    dataController.getAllData();
    superPrint('done');
  }

  void toggleFullScreenMode(){
    xFullScreen = !xFullScreen;
    update();
  }

  void onClickNextOrPrev({required ChapterModel chapterModel,required bool xNext}){
    bool xFirstPage = true;
    bool xLastPage = false;
    try {

      xFirstPage = pageController.page == 0;
      if (!xFirstPage) {
        if (pageController.page == chapterModel.pages.length - 1) {
          xLastPage = true;
        }
      }
    } catch (e) {
      null;
    }
    MangaListController mangaListController = Get.find();
    int? nextChapIndex = chapterModel.getIndex(links: mangaListController.allData);

    if(xNext){
      if (xLastPage) {
        Get.back();
        pageController.jumpToPage(0);
        mangaListController.onClickEachLink(
            link: mangaListController.allData[nextChapIndex! - 1]);
      } else {
        vibrateNow();
        pageController
            .nextPage(
            duration: const Duration(milliseconds: 250),
            curve: Curves.linear)
            .then((value) => update());
      }
    }
    else{
      vibrateNow();
      pageController
          .previousPage(
          duration: const Duration(milliseconds: 250),
          curve: Curves.linear)
          .then((value) => update());
    }

  }

}