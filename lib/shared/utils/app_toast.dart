import 'package:flutter/Material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String message, {ToastGravity? position}) =>
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: position ?? ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
