import 'package:flutter/material.dart';
import 'package:flutter_super_scaffold/flutter_super_scaffold.dart';
import 'package:free_one_piece_manga/modules/manga/v_manga_list_page.dart';
import 'package:free_one_piece_manga/utils/app_colors.dart';
import 'package:free_one_piece_manga/utils/extensions.dart';
import 'package:get/get.dart';

enum HomeTabs{
  home,
  download,
  about
}

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
      pageController.animateToPage(currentIndex, duration: const Duration(milliseconds: 350), curve: Curves.linear);
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

  Widget shownPanel(){
    return PageView(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        MangaListPage(),
        MangaListPage(),
        Center(
          child: Text('Hee Hee'),
        )
      ],
    );
  }

  Widget controlPanel(){
    return Obx(() {
      currentTab.value;
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.15,vertical: 10),
            margin: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 30
            ),
            decoration: BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: HomeTabs.values.map((e) {
                Widget widget = Container();
                int index = HomeTabs.values.indexOf(e);
                bool xSelected = false;
                try{
                  xSelected = pageController.page!.toInt() == index;
                  superPrint(pageController.page!.toInt());
                }
                catch(e){
                  null;
                }


                switch(e){
                  case HomeTabs.home :
                    if(xSelected){
                      widget = Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 4),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(50)
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.home),
                            4.widthBox(),
                            Text(e.name.toUpperCase(),style: const TextStyle(fontWeight: FontWeight.w600,),)
                          ],
                        ),
                      );
                    }
                    else{
                      widget = Icon(Icons.home,color: AppColors.white,);
                    }
                    break;
                  case HomeTabs.download :
                    if(xSelected){
                      widget = Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        alignment: Alignment.center,
                      );
                    }
                    else{
                      widget = Icon(Icons.home,color: AppColors.white,);
                    }
                    break;
                  case HomeTabs.about :
                    if(xSelected){
                      widget = Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        alignment: Alignment.center,
                      );
                    }
                    else{
                      widget = Icon(Icons.home,color: AppColors.white,);
                    }
                    break;
                }

                return widget;
              }).toList(),
            ),
          ),
        ],
      );
    });
  }

}
