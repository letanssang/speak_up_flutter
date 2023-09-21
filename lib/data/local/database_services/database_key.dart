import 'package:speak_up/presentation/utilities/common/convert.dart';

enum SentenceParentType {
  topic,
  pattern,
  expression,
  phrasalVerb,
  idiom,
}

extension SentenceParentTypeExtension on SentenceParentType {
  int get typeNumber => index + 1;
}

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

enum LessonTable {
  lessonID,
  name,
  translation,
  description,
  descriptionTranslation,
  imageURL,
}

extension LessonTableExtension on LessonTable {
  String get field => capitalizeFirstLetter(name);
}

enum CategoryTable {
  categoryID,
  name,
  translation,
  imageURL,
}

extension CategoryTableExtension on CategoryTable {
  String get field => capitalizeFirstLetter(name);
}

enum IdiomTypeTable {
  idiomTypeID,
  name,
  translation,
}

extension IdiomTypeTableExtension on IdiomTypeTable {
  String get field => capitalizeFirstLetter(name);
}

enum IdiomTable {
  idiomID,
  name,
  idiomTypeID,
  description,
  descriptionTranslation,
  audioEndpoint,
}

extension IdiomTableExtension on IdiomTable {
  String get field => capitalizeFirstLetter(name);
}

enum ExpressionTypeTable {
  expressionTypeID,
  name,
  translation,
  description,
  descriptionTranslation,
}

extension ExpressionTypeTableExtension on ExpressionTypeTable {
  String get field => capitalizeFirstLetter(name);
}

enum ExpressionTable {
  expressionID,
  name,
  expressionTypeID,
  translation,
}

extension ExpressionTableExtension on ExpressionTable {
  String get field => capitalizeFirstLetter(name);
}

enum TopicTable {
  topicID,
  topicName,
  translation,
  categoryID,
}

extension TopicTableExtension on TopicTable {
  String get field => capitalizeFirstLetter(name);
}

enum PhoneticTable {
  phoneticID,
  phonetic,
  phoneticType,
  youtubeVideoID,
  example,
  description,
}

extension PhoneticTableExtension on PhoneticTable {
  String get field => capitalizeFirstLetter(name);
}

enum PhrasalVerbTypeTable {
  phrasalVerbTypeID,
  name,
  translation,
}

extension PhrasalVerbTypeTableExtension on PhrasalVerbTypeTable {
  String get field => capitalizeFirstLetter(name);
}

enum PhrasalVerbTable {
  phrasalVerbID,
  name,
  phrasalVerbTypeID,
  description,
  descriptionTranslation,
}

extension PhrasalVerbTableExtension on PhrasalVerbTable {
  String get field => capitalizeFirstLetter(name);
}

enum PatternTable {
  patternID,
  name,
  dialogue,
  description,
  descriptionTranslation,
  youtubeVideoID,
}

extension PatternTableExtension on PatternTable {
  String get field => capitalizeFirstLetter(name);
}

enum SentenceTable {
  sentenceID,
  text,
  audioEndpoint,
  translation,
  parentType,
  parentID,
}

extension SentenceTableExtension on SentenceTable {
  String get field => capitalizeFirstLetter(name);
}
