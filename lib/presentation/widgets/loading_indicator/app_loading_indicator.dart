import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: ScreenUtil().setHeight(100),
        width: ScreenUtil().setHeight(100),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColor.withOpacity(0.2),
        ),
        child: LoadingIndicator(
          indicatorType: Indicator.ballClipRotatePulse,
          strokeWidth: ScreenUtil().setHeight(3),
        ),
      ),
    );
  }
}
