import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_super_scaffold/flutter_super_scaffold.dart';
import 'package:free_one_piece_manga/utils/app_colors.dart';
import 'package:free_one_piece_manga/utils/extensions.dart';
import 'package:get/get.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class DownloadDialogWidget extends StatelessWidget {
  final String text;
  const DownloadDialogWidget({super.key,required this.text});

  @override
  Widget build(BuildContext context) {
    Get.put(DownloadProgressController());
    return GetBuilder<DownloadProgressController>(
      builder: (controller) {
        double minSize = min(Get.width, Get.height);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: minSize * 0.7,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20)
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Downloading',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                  Text(text,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                  30.heightBox(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary,
                                image: DecorationImage(
                                  image: Image.asset('assets/images/luffy_run.gif').image,
                                  fit: BoxFit.cover
                                )
                              ),
                            ),
                          ),
                          SimpleCircularProgressBar(
                            size: minSize*0.65,
                            valueNotifier: controller.valueNotifier,
                            progressStrokeWidth: 16,
                            backStrokeWidth: 1,
                            mergeMode: true,
                            onGetText: (p0) {
                              superPrint(p0);
                              return Text('');
                            },
                            progressColors: const [AppColors.black],
                            backColor: Colors.transparent,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }
    );
  }
}

class DownloadProgressController extends GetxController{
  Rx<double> progress = 0.0.obs;
  ValueNotifier<double> valueNotifier = ValueNotifier(0);

  @override
  void onInit() {
    progress.listen((p0) {
      superPrint("Progress : $p0");
      valueNotifier.value = p0 * 100;
    });
    update();
    super.onInit();
  }


  @override
  void onClose() {
    super.onClose();
  }

  void resetProgress(){
    progress.value = 0;
    update();
  }

  void setProgress({required double p}){
    progress.value = p;
    update();
  }

}
