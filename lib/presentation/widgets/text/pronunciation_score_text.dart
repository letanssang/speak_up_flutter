import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/domain/entities/speech_word/speech_word.dart';
import 'package:speak_up/presentation/utilities/common/phoneme_color.dart';

class PronunciationScoreText extends ConsumerStatefulWidget {
  final List<SpeechWord> words;
  final double fontSize;
  final String recordPath;

  const PronunciationScoreText(
      {super.key,
      required this.words,
      required this.recordPath,
      this.fontSize = 16});

  @override
  ConsumerState<PronunciationScoreText> createState() =>
      _PronunciationScoreTextState();
}

class _PronunciationScoreTextState extends ConsumerState<PronunciationScoreText>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.words.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              children: [
                ...widget.words.map(
                  (word) => wordWidgetSpan(word),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  WidgetSpan wordWidgetSpan(SpeechWord word) {
    return WidgetSpan(
      child: CustomPopupMenu(
        pressType: PressType.singleClick,
        menuBuilder: () => buildWordTooltipMenu(word),
        child: RichText(
            text: TextSpan(
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: widget.fontSize,
          ),
          children: [
            if (word.phonemes != null)
              ...word.phonemes!.map(
                (phoneme) => TextSpan(
                  text: phoneme.phoneme,
                  style: TextStyle(
                    color: getPhonemeColor(phoneme.accuracyScore),
                  ),
                ),
              ),
            const TextSpan(
              text: ' ',
            )
          ],
        )),
      ),
    );
  }

  Widget buildWordTooltipMenu(SpeechWord word) {
    final isDarkTheme = ref.watch(themeProvider);
    return Card(
      elevation: 4,
      color: isDarkTheme ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Table(
            defaultColumnWidth: const IntrinsicColumnWidth(),
            children: [
              TableRow(
                children: [
                  const SizedBox(),
                  if (word.phonemes != null)
                    ...word.phonemes!.map(
                      (e) => TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
                          child: Text(
                            e.phoneme,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: getPhonemeColor(e.accuracyScore),
                              fontSize: ScreenUtil().setSp(20),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              TableRow(children: [
                buildFirstCell(AppLocalizations.of(context)!.score),
                if (word.phonemes != null)
                  ...word.phonemes!.map((e) => TableCell(
                        child: Text(
                          e.accuracyScore.toInt().toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: getPhonemeColor(e.accuracyScore),
                            fontSize: ScreenUtil().setSp(20),
                          ),
                        ),
                      )),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFirstCell(String title) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: ScreenUtil().setSp(16),
          ),
        ),
      ),
    );
  }
}
