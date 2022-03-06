import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/const_files/my_color.dart';
import 'package:whatsapp_clone/view/widgets/sizedBox.dart';

class CommonDialogBoxes {
  void customDialog({required String title, required List<Widget> action}) {
    Get.dialog(
      AlertDialog(
        title: Text(
          title,
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
        ),
        actions: action,
      ),
    );
  }

  void loadingDialog() {
    Get.dialog(
      AlertDialog(
        content: Row(
          children: const [
            CircularProgressIndicator(color: MyColor.buttonColor),
            sizedBoxW16,
            Text("Connecting...")
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }
}
