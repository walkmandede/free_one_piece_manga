import 'package:flutter/material.dart';
import 'package:free_one_piece_manga/utils/app_colors.dart';
import 'package:get/get.dart';

class CommonWidgets{

  static Widget loadingWidget(){
    return Container(
      width: Get.width * 0.05,
      height: Get.width * 0.05,
      child: Image.asset('assets/images/loading2.gif',fit: BoxFit.contain,color: AppColors.primary,),
    );
  }

}