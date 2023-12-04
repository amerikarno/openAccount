class KnowledgeQuestion{
  const KnowledgeQuestion(this.text, this.answers, this.hint);

  final String text;
  final List<String> answers;
  final String hint;


  List<String> getShuffledAnswers() {
    final shuffledList = List.of(answers);
    shuffledList.shuffle();
    return shuffledList;
  }
}
