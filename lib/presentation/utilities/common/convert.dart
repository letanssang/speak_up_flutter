int countWordInSentence(String sentence) {
  final words = sentence.split(' ');
  return words.length;
}

String formatIndexToString(int number) {
  number++;
  if (number < 10) {
    return '0$number';
  } else {
    return number.toString();
  }
}

String capitalizeFirstLetter(String inputString) {
  List<String> words = inputString.split(' ');
  List<String> capitalizedWords = words.map((word) {
    if (word.isNotEmpty) {
      return word[0].toUpperCase() + word.substring(1);
    } else {
      return '';
    }
  }).toList();
  String outputString = capitalizedWords.join(' ');
  return outputString;
}
