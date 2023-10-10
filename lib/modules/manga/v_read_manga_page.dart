import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_super_scaffold/flutter_super_scaffold.dart';
import 'package:free_one_piece_manga/modules/common/common_widgets.dart';
import 'package:free_one_piece_manga/modules/common/m_downloaded_chapter_model.dart';
import 'package:free_one_piece_manga/modules/manga/c_read_manga_controller.dart';
import 'package:free_one_piece_manga/services/vibrate_service.dart';
import 'package:free_one_piece_manga/utils/app_colors.dart';
import 'package:free_one_piece_manga/utils/app_constants.dart';
import 'package:free_one_piece_manga/utils/app_functions.dart';
import 'package:get/get.dart';

class ReadMangaPage extends StatelessWidget {
  final ChapterModel chapterModel;
  const ReadMangaPage({super.key,required this.chapterModel});

  @override
  Widget build(BuildContext context) {
    Get.put(ReadMangaController());
    ReadMangaController controller = Get.find();
    controller.setAsRecentRead(link: chapterModel.link);
    return FlutterSuperScaffold(
      isTopSafe: false,
      appBar: AppBar(
        title: Text(AppFunctions.convertLinkToTitle(link: chapterModel.link)),
      ),
      body: GetBuilder<ReadMangaController>(
        builder: (controller) {
          return Column(
            children: [
              Expanded(child: pagesPanel()),
              controlPanel()
            ],
          );
        },
      ),
    );
  }

  Widget pagesPanel(){
    ReadMangaController controller = Get.find();
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 0,
        vertical: 0
      ),
      child: PageView.builder(
        controller: controller.pageController,
        itemCount: chapterModel.pages.length,
        pageSnapping: true,
        allowImplicitScrolling: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          String src = chapterModel.pages[index];
          return InteractiveViewer(
            child: CachedNetworkImage(
              imageUrl: src,
              fit: BoxFit.contain,
              placeholder: (context, url) {
                return CommonWidgets.loadingWidget();
              },
              errorWidget: (context, url, error) {
                return const Icon(Icons.error);
              },
            ),
          );
        },
      ),
    );
  }

  Widget controlPanel(){
    ReadMangaController controller = Get.find();

    bool xFirstPage = true;
    bool xLastPage = false;

    try{
      if(controller.pageController.page==0){
        xFirstPage = true;
      }
      else if(controller.pageController.page == chapterModel.pages.length - 1){
        xLastPage = true;
      }
    }
    catch(e){
      null;
    }

    return Container(
      padding: EdgeInsets.all(AppConstants.basePadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
              onPressed: () {
                vibrateNow();
                controller.pageController.previousPage(duration: const Duration(milliseconds: 250), curve: Curves.linear);
              },
              child: Text(
                'Prev Page',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: xFirstPage?AppColors.grey:AppColors.primary
                ),)
          ),
          TextButton(
              onPressed: () {
                vibrateNow();
                controller.pageController.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.linear);
              },
              child: Text(
                'Next Page',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: xLastPage?AppColors.grey:AppColors.primary
                ),)
          ),
        ],
      ),
    );
  }

}
