import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/presentation/resources/app_images.dart';

class SavedView extends StatelessWidget {
  const SavedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppImages.nothingHere(),
          const SizedBox(
            height: 32,
          ),
          Text(
            'Nothing here',
            style: TextStyle(
              fontSize: ScreenUtil().setSp(28),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
              'We found nothing in your saved list!\n Let\'s explore and save something.',
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(16),
                color: Colors.grey[600],
              )),
          const SizedBox(
            height: 32,
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text('Explore'),
          )
        ],
      ),
    );
  }
}
