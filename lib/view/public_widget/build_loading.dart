import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../constant/constant.dart';

buildLoadingIndicator(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,

    builder: (BuildContext context) {
      return  Center(
        child: SpinKitDoubleBounce(
          itemBuilder: (BuildContext context, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index.isEven ? mainColor : mainColor.withOpacity(0.5),
              ),
            );
          },
        ),
      );
    },
  );
}

Center buildLoading(){
  return Center(
    child: SpinKitDoubleBounce(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index.isEven ? mainColor : mainColor.withOpacity(0.5),
          ),
        );
      },
    ),
  );
}