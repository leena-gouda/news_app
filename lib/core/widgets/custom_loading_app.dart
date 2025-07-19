import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

void showLoadingApp(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: AppColor.primaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              'برجاء الانتظار...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColor.primaryColor,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}