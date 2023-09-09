import 'package:speak_up/presentation/utilities/common/convert.dart';

enum WordTable {
  wordID,
  word,
  pronunciation,
  phoneticComponents,
  translation,
  phoneticID,
}

extension WordTableExtension on WordTable {
  String get field => capitalizeFirstLetter(name);
}
