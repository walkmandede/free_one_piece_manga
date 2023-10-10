import 'package:flutter/material.dart';
import 'package:free_one_piece_manga/utils/extensions.dart';
import 'package:get/get.dart';

import 'app_colors.dart';

enum DialogType { warning, error, success, message }

class DialogMeta {
  DialogType dialogType;
  String title;
  Color titleColor;

  DialogMeta({
    required this.dialogType,
    required this.title,
    required this.titleColor,
  });
}

class MyDialog {

  void showAlertDialog({
    required String message,
    DialogType dialogType = DialogType.message,
    bool xDismissible = true,
  }) {
    Get.dialog(
        AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            content: DialogWidget(
              message: message.tr,
            )),
        barrierDismissible: xDismissible);
  }

  void showLoadingDialog() {
    Get.dialog(
        AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            content: DialogWidget(
              message: 'Please Wait'.tr,
            )),
        barrierDismissible: false);
  }
  void showConfirmDialog(
      {required String message,
      DialogType dialogType = DialogType.message,
      required Function() onSuccess}) {
    Get.dialog(
        AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            content: ConfirmDialogWidget(
              message: message,
              onConfirm: () {
                onSuccess();
              },
            )),
        barrierDismissible: false);
  }
}

class DialogWidget extends StatelessWidget {
  final String message;

  const DialogWidget(
      {Key? key,
      required this.message,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ],
        ));
  }
}

class ConfirmDialogWidget extends StatelessWidget {
  final String message;
  final Function() onConfirm;

  const ConfirmDialogWidget(
      {Key? key,
      required this.message,
      required this.onConfirm})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            10.heightBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    'Back'.tr,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: AppColors.grey
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    onConfirm();
                  },
                  child: Text(
                    'Confirm'.tr,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
