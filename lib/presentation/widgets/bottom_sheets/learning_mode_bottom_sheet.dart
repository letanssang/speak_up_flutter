import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/presentation/widgets/divider/app_divider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LearningModeBottomSheet extends StatelessWidget {
  final String title;
  final Function()? onTapLecture;
  final Function()? onTapQuiz;
  final Function()? onTapFlashcard;

  const LearningModeBottomSheet({
    super.key,
    this.title = '',
    this.onTapLecture,
    this.onTapQuiz,
    this.onTapFlashcard,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 32, left: 32, bottom: 16),
                child: Text(title,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(18),
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    )),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
                size: 40,
              ),
            ),
            SizedBox(width: ScreenUtil().setWidth(16)),
          ],
        ),
        const AppDivider(),
        const SizedBox(height: 16),
        buildOptionItem(
            context,
            1,
            const Icon(
              Icons.book,
              color: Colors.white,
            ),
            AppLocalizations.of(context)!.lecture,
            onTap: onTapLecture),
        buildOptionItem(
          context,
          2,
          const Icon(Icons.question_answer, color: Colors.white),
          AppLocalizations.of(context)!.quiz,
          onTap: onTapQuiz,
        ),
        buildOptionItem(
            context,
            3,
            const Icon(
              Icons.collections_bookmark,
              color: Colors.white,
            ),
            AppLocalizations.of(context)!.flashCard,
            onTap: onTapFlashcard),
        const SizedBox(height: 64),
      ],
    );
  }

  Widget buildOptionItem(
      BuildContext context, index, Widget? icon, String title,
      {Function()? onTap}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(8)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          radius: 32,
          child: icon,
        ),
        title: Text(title),
        titleTextStyle: TextStyle(
          fontSize: ScreenUtil().setSp(18),
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        trailing: const Icon(Icons.navigate_next_outlined),
      ),
    );
  }
}
