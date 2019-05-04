String capitalizeWord(String word) {
  return word[0].toUpperCase() + word.substring(1).toLowerCase();
}

String capitalizeEachWordInSentence(String sentence) {
  return sentence.split(' ').map(capitalizeWord).join(' ');
}
