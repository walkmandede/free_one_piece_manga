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
import 'package:free_one_piece_manga/utils/extensions.dart';
import 'package:get/get.dart';

class ReadMangaPage extends StatelessWidget {
  final ChapterModel chapterModel;
  const ReadMangaPage({super.key, required this.chapterModel});

  @override
  Widget build(BuildContext context) {
    Get.put(ReadMangaController());
    ReadMangaController controller = Get.find();
    controller.setAsRecentRead(link: chapterModel.link);
    return FlutterSuperScaffold(
      topColor: AppColors.black,
      statusBarBrightness: Brightness.dark,
      statusIconBrightness: Brightness.light,
      isTopSafe: true,
      botColor: AppColors.black,
      // appBar: AppBar(
      //   title: Text(AppFunctions.convertLinkToTitle(link: chapterModel.link)),
      // ),
      body: GetBuilder<ReadMangaController>(
        builder: (controller) {
          return Column(
            children: [
              titleWidget(),
              Expanded(child: pagesPanel()),
              controlPanel(),
            ],
          );
        },
      ),
    );
  }

  Widget titleWidget() {
    String title = AppFunctions.convertLinkToTitle(link: chapterModel.link);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          horizontal: AppConstants.basePadding, vertical: 15),
      decoration: const BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back),
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: AlignmentDirectional.center,
              child: RichText(
                text: TextSpan(
                  text: title.split('-').first,
                  style: const TextStyle(color: AppColors.white, fontSize: 20),
                  children: [
                    TextSpan(
                        text: title.split('-').last,
                        style: const TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget pagesPanel() {
    ReadMangaController controller = Get.find();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
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

  Widget controlPanel() {
    ReadMangaController controller = Get.find();

    bool xFirstPage = true;
    bool xLastPage = false;
    int currentPage = 1;
    try {
      // if (controller.pageController.page == 0) {
      //   xFirstPage = true;
      // } else
      // } else
      print(controller.pageController.page);
      currentPage = (controller.pageController.page?.ceil() ?? 0) + 1;

      xFirstPage = controller.pageController.page == 0;
      if (!xFirstPage) {
        if (controller.pageController.page == chapterModel.pages.length - 1) {
          xLastPage = true;
        }
      }
    } catch (e) {
      null;
    }

    return Container(
      color: AppColors.black,
      padding: EdgeInsets.all(AppConstants.basePadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Visibility(
            visible: !xFirstPage,
            replacement: 70.widthBox(),
            child: InkWell(
              onTap: () {
                vibrateNow();
                controller.pageController
                    .previousPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.linear)
                    .then((value) => controller.update());
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.first_page,
                      color: AppColors.black,
                    ),
                    5.widthBox(),
                    const Text(
                      'Prev',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.black),
                    ),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.dialog(
                  dialogWidget(controller.pageController.page!.ceil() + 1));
            },
            borderRadius: BorderRadius.circular(30),
            child: Column(
              children: [
                RichText(
                  text: TextSpan(
                    text: currentPage.toString(),
                    style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                          text: ' of ${chapterModel.pages.length}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: AppColors.textGrey))
                    ],
                  ),
                ),
                5.heightBox(),
                Container(
                  width: 70,
                  height: 0.5,
                  // padding: const EdgeInsets.only(top: 20),
                  color: AppColors.white,
                )
                // Divider(
                //   color: AppColors.white,
                //   thickness: 0.5,
                //   height: 1,
                // )
              ],
            ),
          ),
          Visibility(
            visible: !xLastPage,
            replacement: 70.widthBox(),
            child: InkWell(
              onTap: () {
                vibrateNow();
                controller.pageController
                    .nextPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.linear)
                    .then((value) => controller.update());
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    const Text(
                      'Next',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.black),
                    ),
                    5.widthBox(),
                    const Icon(
                      Icons.last_page,
                      color: AppColors.black,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // TextButton(
          //     onPressed: () {
          //       vibrateNow();
          //       controller.pageController
          //           .previousPage(
          //               duration: const Duration(milliseconds: 250),
          //               curve: Curves.linear)
          //           .then((value) => controller.update());
          //     },
          //     child: Text(
          //       'Prev Page',
          //       style: TextStyle(
          //           fontWeight: FontWeight.bold,
          //           fontSize: 15,
          //           color: xFirstPage ? AppColors.grey : AppColors.primary),
          //     )),
          // TextButton(
          //     onPressed: () {
          //       vibrateNow();
          //       controller.pageController
          //           .nextPage(
          //               duration: const Duration(milliseconds: 250),
          //               curve: Curves.linear)
          //           .then((value) => controller.update());
          //     },
          //     child: Text(
          //       'Next Page',
          //       style: TextStyle(
          //           fontWeight: FontWeight.bold,
          //           fontSize: 15,
          //           color: xLastPage ? AppColors.grey : AppColors.primary),
          //     )),
        ],
      ),
    );
  }

  Widget dialogWidget(int currentPage) {
    ReadMangaController controller = Get.find();
    String title = AppFunctions.convertLinkToTitle(link: chapterModel.link);
    RxInt currentPageNumber = currentPage.obs;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: AppColors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            text: TextSpan(
              text: title.split('-').first,
              style: const TextStyle(color: AppColors.black, fontSize: 20),
              children: [
                TextSpan(
                    text: title.split('-').last,
                    style: const TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
          ),
          15.heightBox(),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: AppConstants.basePadding, vertical: 10),
            decoration: BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    vibrateNow();
                    controller.pageController
                        .animateTo(3,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.linear)
                        .then((value) => controller.update());
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                    decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(30)),
                    child: const Text(
                      'Go To',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                DropdownButton(
                    items: List.generate(
                        chapterModel.pages.length,
                        (index) => DropdownMenuItem(
                            value: (index + 1), child: Text('${index + 1}'))),
                    onChanged: (index) {
                      print(index);
                    })
              ],
            ),
          )
        ],
      ),
    );
  }
}
