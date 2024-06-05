import 'dart:io';
import '../../core/constants/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.color});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 28,
        width: 28,
        child: kIsWeb || Platform.isAndroid
            ? CircularProgressIndicator(
                color: color ?? AppColors.primaryColor,
              )
            : Platform.isIOS
                ? CupertinoActivityIndicator(
                    color: color ?? AppColors.primaryColor)
                : CircularProgressIndicator(
                    color: color ?? AppColors.primaryColor),
      ),
    );
  }
}
