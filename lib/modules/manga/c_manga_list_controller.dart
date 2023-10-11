import 'dart:convert';

import 'package:flutter_super_scaffold/flutter_super_scaffold.dart';
import 'package:free_one_piece_manga/data/common_data.dart';
import 'package:free_one_piece_manga/modules/common/c_data_controller.dart';
import 'package:free_one_piece_manga/modules/common/m_downloaded_chapter_model.dart';
import 'package:free_one_piece_manga/modules/manga/v_read_manga_page.dart';
import 'package:free_one_piece_manga/services/sp_service.dart';
import 'package:free_one_piece_manga/services/vibrate_service.dart';
import 'package:free_one_piece_manga/utils/custom_dialog.dart';
import 'package:get/get.dart';
import 'package:chaleno/chaleno.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MangaListController extends GetxController{

  bool xLoading = false;
  List<String> allData = [];
  DataController dataController = Get.find();


  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }




  Future<void> fetchData() async{
    xLoading = true;
    allData.clear();
    update();
    await dataController.getAllData();
    var parser = await Chaleno().load(CommonData.opHomePageLink);
    if(parser!=null){
      List<Result> results = parser!.getElementsByClassName('comic-thumb-title');
      allData.addAll(results.map((e) => e.href.toString()));
    }
    else{
      superPrint('parsing error');
    }
    xLoading = false;
    update();
  }

  Future<void> onClickEachLink({required String link}) async{
    bool xDownloaded = dataController.xChapterIsDownloaded(link: link);
    if(xDownloaded){
      offlineRead(link: link);
    }
    else{
      await _onlineRead(link: link);
    }
  }

  void offlineRead({required String link}){
    ChapterModel chapterModel = dataController.downloadedChapters.where((element) => element.link == link).first;
    Get.to(()=> ReadMangaPage(chapterModel: chapterModel));
  }

  Future<void> _onlineRead({required String link}) async{
    vibrateNow();
    MyDialog().showLoadingDialog();
    final pages = await scrapThisChapter(link: link);
    Get.back();
    if(pages!=null){
      Get.to(()=> ReadMangaPage(
        chapterModel: ChapterModel(
            link: link,
            pages: pages
        ),
      ));
    }
  }

  Future<void> onClickDownload({required String link}) async{
    vibrateNow();
    bool xSuccess = false;
    MyDialog().showLoadingDialog();
    try{
      superPrint('start');
      List<String>? pages = await scrapThisChapter(link: link);
      if(pages!=null){
        ChapterModel downloadedChapterModel = ChapterModel(link: link, pages: pages);
        xSuccess = await downloadedChapterModel.cacheMe(
          onSuccessEach: (p0) {
            superPrint(p0);
          },
        );
        if(xSuccess){
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          List<String> downloadedData = sharedPreferences.getStringList(SpService.downloadKey)??[];
          downloadedData.add(jsonEncode(downloadedChapterModel.toMap()));
          bool xResult = await sharedPreferences.setStringList(SpService.downloadKey, downloadedData);
          if(xResult){
            await dataController.getAllData();
          }
          else{

          }
        }
        else{
          superPrint('download fail');
        }
      }
    }
    catch(e){
      superPrint(e);
      null;
    }
    Get.back();
    if(xSuccess){
      MyDialog().showAlertDialog(message: 'Successfully Downloaded');
    }
    else{
      MyDialog().showAlertDialog(message: 'Something went wrong');
    }
  }



  Future<List<String>?> scrapThisChapter({required String link}) async{
    List<String>? result;
    try{
      var parser = await Chaleno().load(link);
      if(parser!=null){
        final rawResult1 = parser.getElementsByTagName('img');
        if(rawResult1!=null){
          result = [];
          for (var value1 in rawResult1) {
            String src = value1!.src??'';
            String alt = value1.alt??'';
            result.add(value1.src!);
          }
        }
      }
      else{
        superPrint('parsing error');
      }
    }
    catch(e){
      superPrint(e);
      null;
    }

    return result;

  }

}
