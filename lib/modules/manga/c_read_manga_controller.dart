import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_super_scaffold/flutter_super_scaffold.dart';
import 'package:free_one_piece_manga/modules/common/c_data_controller.dart';
import 'package:free_one_piece_manga/services/sp_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

}