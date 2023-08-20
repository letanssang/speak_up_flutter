class Quiz {
  final String question;
  final List<String> answers;
  final int correctAnswerIndex;

  const Quiz({
    required this.question,
    required this.answers,
    required this.correctAnswerIndex,
  });
}
