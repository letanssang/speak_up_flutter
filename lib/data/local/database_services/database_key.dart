enum WordTable {
  WordID,
  Word,
  Pronunciation,
  PhoneticComponents,
  Translation,
  PhoneticID,
}

enum LessonTable {
  LessonID,
  Name,
  Translation,
  Description,
  DescriptionTranslation,
  ImageURL,
}

enum CategoryTable {
  CategoryID,
  Name,
  Translation,
  ImageURL,
}

enum IdiomTypeTable {
  IdiomTypeID,
  Name,
  Translation,
}

enum IdiomTable {
  IdiomID,
  Name,
  IdiomTypeID,
  Description,
  DescriptionTranslation,
  AudioEndpoint,
}

enum ExpressionTypeTable {
  ExpressionTypeID,
  Name,
  Translation,
  Description,
  DescriptionTranslation,
}

enum ExpressionTable {
  ExpressionID,
  Name,
  ExpressionTypeID,
  Translation,
}

enum TopicTable {
  TopicID,
  TopicName,
  Translation,
  CategoryID,
}

enum PhoneticTable {
  PhoneticID,
  Phonetic,
  PhoneticType,
  YoutubeVideoID,
  Example,
  Description,
}

enum PhrasalVerbTypeTable {
  PhrasalVerbTypeID,
  Name,
  Translation,
}

enum PhrasalVerbTable {
  PhrasalVerbID,
  Name,
  PhrasalVerbTypeID,
  Description,
  DescriptionTranslation,
}

enum PatternTable {
  PatternID,
  Name,
  Dialogue,
  Description,
  DescriptionTranslation,
  YoutubeVideoID,
}

enum SentenceTable {
  SentenceID,
  Text,
  AudioEndpoint,
  Translation,
  ParentType,
  ParentID,
}

enum CommonWordTable {
  CommonWordID,
  CommonWord,
  Translation,
  PartOfSpeech,
  Level,
  Type
}

enum TenseTable {
  TenseID,
  Tense,
  Translation,
  SignalWords,
}

enum TenseFormTable {
  TenseFormID,
  TenseID,
  Title,
  Positive,
  PositiveExample,
  Negative,
  NegativeExample,
  Question,
  QuestionExample,
}

enum TenseUsageTable {
  TenseUsageID,
  TenseID,
  Description,
  DescriptionTranslation,
  Example,
}
