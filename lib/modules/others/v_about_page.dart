
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_super_scaffold/flutter_super_scaffold.dart';
import 'package:free_one_piece_manga/utils/app_constants.dart';
import 'package:free_one_piece_manga/utils/custom_dialog.dart';
import 'package:free_one_piece_manga/utils/extensions.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../utils/app_colors.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.white
        ),
        padding: EdgeInsets.only(
          left: AppConstants.basePadding,
          right: AppConstants.basePadding,
          top: AppConstants.basePadding,
          bottom: Get.height * 0.15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/app_logo.png',width: Get.width*0.25,),
            5.heightBox(),
            const Text('Free One Piece Manga',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),
            const Text('Version : 1.0.0'),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.black,
                  width: 2
                ),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Disclosure',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: AppColors.black),),
                      6.heightBox(),
                      const Text(
                        'This app is an act of Web scraping from One Piece Manga Online.'
                            'We recommend you to purchase officially form the original author if you enjoy their creations',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.black
                    ),
                  )
                ],
              ),
            )

            // TextButton.icon(
            //   onPressed: () async{
            //     MyDialog().showLoadingDialog();
            //     try {
            //       final cacheDir = await getTemporaryDirectory();
            //       if (cacheDir.existsSync()) {
            //         final cacheFiles = cacheDir.listSync();
            //         for (var cacheFile in cacheFiles) {
            //           superPrint(cacheFile);
            //           if (cacheFile is File) {
            //             cacheFile.deleteSync();
            //           }
            //         }
            //       }
            //     } catch (e) {
            //       superPrint(e);
            //       null;
            //     }
            //     Get.back();
            //     MyDialog().showAlertDialog(message: 'Done');
            //   },
            //   icon: const Icon(Icons.delete_forever_rounded,color: Colors.red,),
            //   label: const Text('Clear Cache',style: TextStyle(fontSize: 20,color: Colors.red,fontWeight: FontWeight.w600),),
            // )
          ],
        ),
      ),
    );
  }
}
