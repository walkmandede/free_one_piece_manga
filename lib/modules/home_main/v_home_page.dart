import 'package:flutter/material.dart';
import 'package:flutter_super_scaffold/flutter_super_scaffold.dart';
import 'package:free_one_piece_manga/modules/manga/v_manga_list_page.dart';
import 'package:free_one_piece_manga/modules/manga/w_download_dialog_widget.dart';
import 'package:free_one_piece_manga/modules/others/v_about_page.dart';
import 'package:free_one_piece_manga/services/vibrate_service.dart';
import 'package:free_one_piece_manga/utils/app_colors.dart';
import 'package:free_one_piece_manga/utils/extensions.dart';
import 'package:get/get.dart';

enum HomeTabs { home, download, about }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Rx<HomeTabs> currentTab = HomeTabs.home.obs;
  PageController pageController = PageController();

  @override
  void initState() {
    currentTab.listen((p0) {
      int currentIndex = HomeTabs.values.indexOf(p0);
      pageController.animateToPage(currentIndex,
          duration: const Duration(milliseconds: 350), curve: Curves.linear);
    });
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox.expand(
        child: Stack(
          children: [
            shownPanel(),
            Align(
              alignment: Alignment.bottomCenter,
              child: controlPanel(),
            )
          ],
        ),
      ),
    );
  }

  Widget shownPanel() {
    return PageView(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        MangaListPage(
          xDownload: false,
        ),
        MangaListPage(
          xDownload: true,
        ),
        AboutPage()
      ],
    );
  }

  Widget controlPanel() {
    return Obx(() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            decoration: BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.circular(25)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: HomeTabs.values.map((e) {
                Widget widget = Container();
                int index = HomeTabs.values.indexOf(e);
                bool xSelected = false;
                try {
                  xSelected = currentTab.value == e;
                } catch (e) {
                  null;
                }
                switch (e) {
                  case HomeTabs.home:
                    if (xSelected) {
                      widget = Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 7),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(1000000)),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.home_filled,
                              color: AppColors.black,
                            ),
                            4.widthBox(),
                            Text(
                              e.name.capitalizeFirst ?? '',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            )
                          ],
                        ),
                      );
                    } else {
                      widget = const Icon(
                        Icons.home_filled,
                        color: AppColors.white,
                      );
                    }
                    break;
                  case HomeTabs.download:
                    if (xSelected) {
                      widget = Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 7),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(1000000)),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.archive_rounded,
                              color: AppColors.black,
                            ),
                            4.widthBox(),
                            Text(
                              e.name.capitalizeFirst ?? '',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            )
                          ],
                        ),
                      );
                    } else {
                      widget = const Icon(
                        Icons.archive_rounded,
                        color: AppColors.white,
                      );
                    }
                    break;
                  case HomeTabs.about:
                    if (xSelected) {
                      widget = Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 7),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(1000000)),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_rounded,
                              color: AppColors.black,
                            ),
                            4.widthBox(),
                            Text(
                              e.name.capitalizeFirst ?? '',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            )
                          ],
                        ),
                      );
                    } else {
                      widget = const Icon(
                        Icons.info_rounded,
                        color: AppColors.white,
                      );
                    }
                    break;
                }

                return GestureDetector(
                  onTap: () {
                    vibrateNow();
                    currentTab.value = HomeTabs.values[index];
                    currentTab.refresh();
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: widget,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      );
    });
  }
}
