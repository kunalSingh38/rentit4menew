import 'package:flutter/material.dart';
import 'package:rentit4me_new/helper/exit_confirmation_dialog.dart';
import 'package:rentit4me_new/helper/logout_confirmation_dialog.dart';
import 'package:rentit4me_new/helper/view_image_dialog.dart';

class DialogHelper {
  static exit(context) => showDialog(
      context: context, builder: (context) => ExitConfirmationDialog());
  static logout(context) => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LogoutConfirmationDialog());
  static viewimagedialog(String image, context) => showDialog(
      context: context, builder: (context) => ViewImageDialog(image: image));
}
