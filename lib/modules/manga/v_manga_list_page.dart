import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:free_one_piece_manga/modules/common/c_data_controller.dart';
import 'package:free_one_piece_manga/modules/common/common_widgets.dart';
import 'package:free_one_piece_manga/modules/manga/c_manga_list_controller.dart';
import 'package:free_one_piece_manga/services/vibrate_service.dart';
import 'package:free_one_piece_manga/utils/app_colors.dart';
import 'package:free_one_piece_manga/utils/app_constants.dart';
import 'package:free_one_piece_manga/utils/app_functions.dart';
import 'package:free_one_piece_manga/utils/extensions.dart';
import 'package:get/get.dart';
import 'package:flutter_super_scaffold/flutter_super_scaffold.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'dart:io';

class MangaListPage extends StatefulWidget {
  final bool xDownload;
  const MangaListPage({super.key,required this.xDownload});

  @override
  State<MangaListPage> createState() => _MangaListPageState();
}

class _MangaListPageState extends State<MangaListPage> {
  DataController dataController = Get.find();

  @override
  void initState() {
    // initLoad();
    super.initState();
  }

  Future<void> initLoad() async{

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    Get.put(MangaListController());

    MangaListController mangaListController = Get.find();
    mangaListController.updateDownloadSize();
    // mangaListController.initLoad();
    return GetBuilder<DataController>(
      builder: (dataController) {
        String lastReadChapter = '-';
        try{
          lastReadChapter = AppFunctions.convertLinkToTitle(link: dataController.recentChapterReadLink);
        }
        catch(e){
          null;
        }
        return GetBuilder<MangaListController>(
          builder: (controller) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.black,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(10)
                  )
                ),
                title: GestureDetector(
                  onTap: () {
                    vibrateNow();
                    controller.onClickLastReadChapter();
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.transparent
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(widget.xDownload?'Total Download Size':'Last Read Chapter',style: TextStyle(color: AppColors.white,fontSize: 20,fontWeight: FontWeight.w500),),
                        10.widthBox(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,vertical: 7
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            widget.xDownload?'${controller.totalCachedSize} MB':lastReadChapter,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              body: SizedBox.expand(
                child: GetBuilder<MangaListController>(
                  builder: (controller) {
                    if(controller.xLoading){
                      return CommonWidgets.loadingWidget();
                    }
                    else{
                      return Column(
                        children: [
                          Expanded(child: dataPanel())
                        ],
                      );
                    }
                  },
                )
              ),
            );
          }
        );
      }
    );
  }

  Widget dataPanel(){

    MangaListController controller = Get.find();

    if(controller.allData.isEmpty){
      return const Center(
        child: Text('No Data Yet!'),
      );
    }
    else{
      List<String> data = [];

      if(widget.xDownload){
        data.addAll(
            controller.allData.where((element) => dataController.xChapterIsDownloaded(link: element))
        );
      }
      else{
        data.addAll(
            controller.allData
        );
      }

      if(data.isEmpty){
        return const Center(
          child: Text('No Data Yet'),
        );
      }

     return ScrollablePositionedList.builder(
       itemScrollController: widget.xDownload?null:controller.itemScrollController,
       padding: EdgeInsets.only(
         bottom: Get.height * 0.2
       ),
       itemCount: data.length,
       itemBuilder: (context, index) {
         String link = data[index]??'';
         bool xDownloaded = dataController.xChapterIsDownloaded(link: link);
         bool xLastRead = dataController.recentChapterReadLink == link;
         return GestureDetector(
           onTap: () {
             controller.onClickEachLink(link: link);
           },
           child: Stack(
             children: [
               Container(
                   width: double.infinity,
                   alignment: Alignment.centerLeft,
                   padding: EdgeInsets.symmetric(
                       horizontal: AppConstants.basePadding,
                       vertical: 12,
                   ),
                   decoration: BoxDecoration(
                       color: xLastRead?AppColors.primary.withOpacity(0.4):Colors.transparent,
                       border: Border(
                           bottom: BorderSide(
                             color: AppColors.textGrey.withOpacity(0.5),
                           )
                       )
                   ),
                   child: Row(
                     children: [
                       Expanded(
                         child: Text(
                           'Chapter : ${AppFunctions.convertLinkToTitle(link: link)}',
                           style: const TextStyle(
                             fontWeight: FontWeight.w600,
                             fontSize: 18
                           ),
                         ),
                       ),
                       4.widthBox(),
                       Opacity(
                         opacity: xDownloaded?0:1,
                         child: GestureDetector(
                           onTap: () {
                             if(!xDownloaded){
                               controller.onClickDownload(link: link);
                             }
                           },
                           child: Container(
                             padding: const EdgeInsets.all(6),
                             decoration: BoxDecoration(
                               shape: BoxShape.circle,
                               color: AppColors.primary,
                               border: Border.all(
                                 color: AppColors.black
                               ),
                             ),
                             child: Column(
                               children: [
                                 const Icon(Icons.arrow_downward,size: 15,),
                                 Container(
                                   width: 10,
                                   height: 1,
                                   decoration: const BoxDecoration(
                                     color: AppColors.black
                                   ),
                                 )
                               ],
                             ),
                           ),
                         ),
                       ),
                     ],
                   )
               ),
               if(xLastRead)const Icon(
                 Icons.bookmark_rounded,
                 size: 15,
               )
             ],
           ),
         );
       },
     );
    }
  }


}
