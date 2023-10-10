import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:free_one_piece_manga/modules/common/c_data_controller.dart';
import 'package:free_one_piece_manga/modules/common/common_widgets.dart';
import 'package:free_one_piece_manga/modules/common/m_downloaded_chapter_model.dart';
import 'package:free_one_piece_manga/modules/home_main/c_home_controller.dart';
import 'package:free_one_piece_manga/modules/manga/v_read_manga_page.dart';
import 'package:free_one_piece_manga/services/vibrate_service.dart';
import 'package:free_one_piece_manga/utils/app_colors.dart';
import 'package:free_one_piece_manga/utils/app_constants.dart';
import 'package:free_one_piece_manga/utils/app_functions.dart';
import 'package:free_one_piece_manga/utils/extensions.dart';
import 'package:get/get.dart';
import 'package:flutter_super_scaffold/flutter_super_scaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    Get.put(HomePageController());
    return FlutterSuperScaffold(
      isTopSafe: false,
      isBotSafe: true,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('One Piece Manga Free',style: TextStyle(color: AppColors.white,fontWeight: FontWeight.w600),),
        actions: [
          if(kDebugMode)IconButton(onPressed: () async{
            SharedPreferences sp = await SharedPreferences.getInstance();
            await sp.clear();
          }, icon: const Icon(Icons.settings))
        ],
      ),
      body: SizedBox.expand(
        child: GetBuilder<HomePageController>(
          builder: (controller) {
            if(controller.xLoading){
              return CommonWidgets.loadingWidget();
            }
            else{

              return Column(
                children: [
                  lastReadPanel(),
                  Expanded(child: dataPanel())
                ],
              );
            }
          },
        )
      ),
    );
  }

  Widget lastReadPanel(){
    HomePageController controller = Get.find();
    return GetBuilder<DataController>(
      builder: (dataController) {
        String recentLink = '';

        try{
          recentLink = AppFunctions.convertLinkToTitle(link: dataController.recentChapterReadLink);
        }
        catch(e){
          null;
        }


        if(recentLink.isEmpty){
          return Container();
        }
        else{
          return GestureDetector(
            onTap: () {
              vibrateNow();
              controller.onClickEachLink(link: recentLink);
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(
                  AppConstants.basePadding
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.4)
              ),
              alignment: Alignment.center,
              child: Text(
                'Recent Chapter : $recentLink',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.black
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget dataPanel(){

    HomePageController controller = Get.find();

    if(controller.allData.isEmpty){
      return const Center(
        child: Text('No Data Yet!'),
      );
    }
    else{
      return GetBuilder<DataController>(
        builder: (dataController) {
          return Scrollbar(
            child: ListView.builder(
              padding: EdgeInsets.all(AppConstants.basePadding),
              itemCount: controller.allData.length,
              itemBuilder: (context, index) {
                String link = controller.allData[index]??'';
                bool xDownloaded = dataController.xChapterIsDownloaded(link: link);
                return GestureDetector(
                  onTap: () {
                    controller.onClickEachLink(link: link);
                  },
                  child: Container(
                      width: double.infinity,
                      height: AppConstants.buttonSize,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border(
                              bottom: BorderSide(
                                  color: AppColors.grey.withOpacity(0.2)
                              )
                          )
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(AppFunctions.convertLinkToTitle(link: link)),
                          ),
                          10.widthBox(),
                          if(!xDownloaded)IconButton(onPressed: () {
                            controller.onClickDownload(link: link);
                          }, icon: const Icon(Icons.download_rounded)),
                        ],
                      )
                  ),
                );
              },
            ),
          );
        },
      );

    }
  }


}
