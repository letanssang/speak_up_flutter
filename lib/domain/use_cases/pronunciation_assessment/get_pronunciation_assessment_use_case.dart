import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:speak_up/data/repositories/speech_to_text/speech_to_text_repository.dart';
import 'package:speak_up/domain/entities/speech_sentence/speech_sentence.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class GetPronunciationAssessmentUseCase
    extends FutureUseCaseTwoInput<String, String, dynamic> {
  @override
  Future<SpeechSentence> run(String referenceText, String recordPath) async {
    final pronAssessmentParamsMap = {
      "ReferenceText": referenceText,
      "GradingSystem": "HundredMark",
      "Granularity": "Phoneme",
      "PhonemeAlphabet": "IPA",
      "Dimension": "Comprehensive"
    };
    final audioBytes = File(recordPath).readAsBytesSync();
    final pronAssessmentParamsJson = json.encode(pronAssessmentParamsMap);
    final pronAssessmentParamsBytes =
        Uint8List.fromList(utf8.encode(pronAssessmentParamsJson));
    final pronAssessmentHeader = base64.encode(pronAssessmentParamsBytes);

    return injector
        .get<SpeechToTextRepository>()
        .getPronunciationAssessment(pronAssessmentHeader, audioBytes);
  }
}
