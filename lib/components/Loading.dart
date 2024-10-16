import 'package:flutter/material.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

void showProgressDialog(String message, SimpleFontelicoProgressDialog dialog, BuildContext context) {
  dialog.show(
      message: message,
      textStyle: const TextStyle(color: Colors.white),
      type: SimpleFontelicoProgressDialogType.custom,
      loadingIndicator: LoadingAnimationWidget.fourRotatingDots(
        color: Colors.white,
        size: 50,
      ),
      backgroundColor: Colors.transparent,
      horizontal: false,
      width: MediaQuery.of(context).size.width * 0.486,
      height: MediaQuery.of(context).size.height * 0.183,
      indicatorColor: Colors.white);
}

void hideProgressDialog(SimpleFontelicoProgressDialog dialog) {
  dialog.hide();
}

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    double defaultWidth = MediaQuery.of(context).size.width;
    double defaultHeight = MediaQuery.of(context).size.height;

    return Container(
      color: Colors.white,
      width: defaultWidth,
      height: defaultHeight,
      child: Center(
          child: LoadingAnimationWidget.fourRotatingDots(
            color: Colors.black,
            size: 50,
          )),
    );
  }
}