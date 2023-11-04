import 'package:flutter/material.dart';
import 'package:speak_up/presentation/utilities/common/phoneme_color.dart';
import 'package:speak_up/presentation/widgets/percent_indicator/app_circular_percent_indicator.dart';
import 'package:speak_up/presentation/widgets/percent_indicator/app_linear_percent_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PronunciationScoreCard extends StatelessWidget {
  final double pronunciationScore;
  final double accuracyScore;
  final double fluencyScore;
  final double completenessScore;

  const PronunciationScoreCard(
      {super.key,
      required this.pronunciationScore,
      required this.accuracyScore,
      required this.fluencyScore,
      required this.completenessScore});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                AppCircularPercentIndicator(
                  title: pronunciationScore.toInt().toString(),
                  titleSize: 40,
                  percent: pronunciationScore / 100,
                  radius: 64,
                  lineWidth: 16,
                  progressColor: getPhonemeColor(pronunciationScore),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    AppLocalizations.of(context)!.pronunciationScore,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppLinearPercentIndicator(
                  title: AppLocalizations.of(context)!.accuracy,
                  percent: accuracyScore / 100,
                  lineHeight: 10,
                  progressColor: getPhonemeColor(accuracyScore),
                ),
                AppLinearPercentIndicator(
                  title: AppLocalizations.of(context)!.fluency,
                  percent: fluencyScore / 100,
                  lineHeight: 10,
                  progressColor: getPhonemeColor(fluencyScore),
                ),
                AppLinearPercentIndicator(
                  title: AppLocalizations.of(context)!.completeness,
                  percent: completenessScore / 100,
                  lineHeight: 10,
                  progressColor: getPhonemeColor(completenessScore),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
